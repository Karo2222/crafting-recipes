import 'package:flutter/widgets.dart';
import 'package:craftingrecipes/languages/de.dart';
import 'package:craftingrecipes/languages/en.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/languages/supported_languages.dart';

/// Provides the [Languages] implementation for the active locale.
class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => SupportedLanguages.all
      .any((supported) => supported.languageCode == locale.languageCode);

  @override
  Future<Languages> load(Locale locale) async =>
      locale.languageCode == 'de' ? LanguageDe() : LanguageEn();

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
