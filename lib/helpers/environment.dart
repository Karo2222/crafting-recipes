/// Build-time configuration, passed with `--dart-define-from-file`.
abstract final class Environment {
  static const String supabaseURL = String.fromEnvironment('supabaseURL');
  static const String publishableKey =
      String.fromEnvironment('publishableKey');

  /// Redirect target for e-mail confirmation links on mobile and desktop.
  static const String authCallbackURL = 'craftingrecipes://auth-callback/';

  /// How many recipe and step images are cached during a sync.
  static const int numberOfRecipeImagesToDownload =
      int.fromEnvironment('numberOfRecipeImagesToDownload', defaultValue: 10);
  static const int numberOfStepImagesToDownload = int.fromEnvironment(
    'numberOfStepImagesToDownload',
    defaultValue: 60,
  );
}
