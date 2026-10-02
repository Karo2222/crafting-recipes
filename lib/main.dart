import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:craftingrecipes/helpers/account_auth.dart';
import 'package:craftingrecipes/helpers/device_info.dart';
import 'package:craftingrecipes/helpers/environment.dart';
import 'package:craftingrecipes/helpers/localstorage/drift_to_supabase.dart';
import 'package:craftingrecipes/helpers/localstorage/key_value.dart';
import 'package:craftingrecipes/helpers/localstorage/realtime.dart';
import 'package:craftingrecipes/helpers/push_notifications.dart';
import 'package:craftingrecipes/languages/app_localizations.dart';
import 'package:craftingrecipes/languages/supported_languages.dart';
import 'package:craftingrecipes/objects/scanner.dart';
import 'package:craftingrecipes/views/login.dart';
import 'package:craftingrecipes/views/second_homepage.dart';

/// Shared Supabase client.
final supabase = Supabase.instance.client;

/// Ids of the signed-in account and the active profile, if any.
int? currentAccount;
int? currentProfile;

final logger = Logger(
  printer: PrettyPrinter(methodCount: 2, errorMethodCount: 8, lineLength: 120),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await PushNotifications.initializeAndroid();
  await Supabase.initialize(
    url: Environment.supabaseURL,
    publishableKey: Environment.publishableKey,
  );
  await KeyValue.initialize();
  await AccountAuth.restoreSession();
  DriftToSupabase.initializeOfflineSync();
  logger.i('Starting with account $currentAccount, profile $currentProfile');

  runApp(
    p.ChangeNotifierProvider(
      create: (_) => ScanModel(),
      child: const RecipesApp(),
    ),
  );
}

/// Extracts the recipe id from links like `.../recipe/<id>`.
String? recipeIdFromUri(Uri uri) {
  final segments = uri.pathSegments;
  final index = segments.indexOf('recipe');
  return index >= 0 && index + 1 < segments.length ? segments[index + 1] : null;
}

class RecipesApp extends StatefulWidget {
  const RecipesApp({super.key});

  /// Changes the app language at runtime.
  static void setLocale(BuildContext context, Locale locale) =>
      context.findAncestorStateOfType<_RecipesAppState>()?._setLocale(locale);

  /// Switches between light, dark and system theme at runtime.
  static void setTheme(BuildContext context, ThemeMode mode) =>
      context.findAncestorStateOfType<_RecipesAppState>()?._setTheme(mode);

  @override
  State<RecipesApp> createState() => _RecipesAppState();
}

class _RecipesAppState extends State<RecipesApp> {
  static bool _launchLinkHandled = false;

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  void _setLocale(Locale locale) => setState(() => _locale = locale);
  void _setTheme(ThemeMode mode) => setState(() => _themeMode = mode);

  @override
  void initState() {
    super.initState();
    Realtime.start();
    if (kIsWeb || DeviceInfo.isDevice()) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _listenForLinks());
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    unawaited(Realtime.stop());
    super.dispose();
  }

  /// Opens recipes from deep links: once for the link that launched the app
  /// and then for every link received while it is running.
  Future<void> _listenForLinks() async {
    if (!_launchLinkHandled) {
      _launchLinkHandled = true;
      try {
        final launchLink =
            kIsWeb ? Uri.base : await _appLinks.getInitialLink();
        if (launchLink != null) _openRecipeLink(launchLink);
      } on PlatformException catch (error) {
        logger.w('Could not read the launch link: $error');
      } on FormatException catch (error) {
        logger.w('Malformed launch link: $error');
      }
    }
    if (!kIsWeb) {
      _linkSubscription = _appLinks.uriLinkStream.listen(
        _openRecipeLink,
        onError: (Object error) => logger.w('Deep link error: $error'),
      );
    }
  }

  void _openRecipeLink(Uri link) {
    final recipeId = recipeIdFromUri(link);
    if (recipeId == null || !mounted) return;
    p.Provider.of<ScanModel>(context, listen: false).updateText(recipeId);
  }

  /// Exact match first, then same language, otherwise the first supported one.
  static Locale _resolveLocale(Locale? device, Iterable<Locale> supported) {
    if (device == null) return supported.first;
    return supported.firstWhere(
      (l) => l == device,
      orElse: () => supported.firstWhere(
        (l) => l.languageCode == device.languageCode,
        orElse: () => supported.first,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signedIn =
        supabase.auth.currentSession != null && currentAccount != null;
    return MaterialApp(
      title: 'Crafting Recipes',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: SupportedLanguages.all,
      localeResolutionCallback: _resolveLocale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5CACFC)),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      // Tapping anywhere outside a text field closes the keyboard.
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: child,
      ),
      home: signedIn ? const SecondHomePage() : const LoginPage(),
    );
  }
}
