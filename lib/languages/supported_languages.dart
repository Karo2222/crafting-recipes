import 'dart:ui' show Locale;

/// Locales the app ships translations for.
abstract final class SupportedLanguages {
  static const List<Locale> all = [Locale('en'), Locale('de')];
}
