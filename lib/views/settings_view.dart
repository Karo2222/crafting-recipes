import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/account_auth.dart';
import 'package:craftingrecipes/helpers/app_info.dart';
import 'package:craftingrecipes/helpers/localstorage/app_util.dart';
import 'package:craftingrecipes/helpers/localstorage/key_value.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/helpers/recipe_permissions.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/languages/supported_languages.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:craftingrecipes/views/login.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final List<Locale> languages = SupportedLanguages.all;
  AppInfo? appInfo;

  @override
  void initState() {
    super.initState();
    appInformation().then((info) {
      if (mounted) setState(() => appInfo = info);
    });
  }

  static WidgetStateProperty<Icon?> _switchIcon(IconData on, IconData off) =>
      WidgetStateProperty.resolveWith(
        (states) => Icon(states.contains(WidgetState.selected) ? on : off),
      );

  final thumbIcon = _switchIcon(Icons.check, Icons.close);
  final themeIcon = _switchIcon(Icons.light_mode, Icons.dark_mode);

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final accountId = currentAccount;
    if (accountId == null) {
      return Center(child: Text(l.accountNotAvailable));
    }
    final settingsStream = Singleton().getDatabase().getSettings(accountId);
    final colors = Theme.of(context).colorScheme;
    return FutureBuilder<bool>(
      future: RecipePermissions.canModifyContent(),
      builder: (context, permissionSnapshot) {
        final canModify = permissionSnapshot.data == true;
        return ColoredBox(
          color: colors.surfaceContainerLow,
          child: StreamBuilder<List<Setting>>(
            stream: settingsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('${l.somethingWentWrong} ${snapshot.error}'),
                );
              }

              final setting = snapshot.data?.firstOrNull;
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SettingsSectionHeading(
                            icon: Icons.tune_outlined,
                            title: l.preferences,
                          ),
                          const SizedBox(height: 10),
                          _SettingsPanel(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: DropdownButtonFormField<Locale>(
                                  key: const Key('dropdown'),
                                  isExpanded: true,
                                  value: Locale(
                                    setting?.language ?? l.languageCode,
                                  ),
                                  items: languages
                                      .map(
                                        (locale) => DropdownMenuItem<Locale>(
                                          value: locale,
                                          child: Text(
                                            _languageLabel(locale),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: canModify && setting != null
                                      ? onLanguageChange
                                      : null,
                                  decoration: InputDecoration(
                                    labelText: l.languages,
                                    prefixIcon:
                                        const Icon(Icons.language_outlined),
                                    filled: true,
                                    fillColor: colors.surfaceContainerLowest,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const Divider(height: 1),
                              SwitchListTile(
                                secondary: const Icon(Icons.sync_alt_outlined),
                                title: Text(l.realtime),
                                subtitle: Text(l.realtimeText),
                                thumbIcon: thumbIcon,
                                value: setting?.realtime ?? false,
                                onChanged: canModify && setting != null
                                    ? onRealtimeChange
                                    : null,
                              ),
                              const Divider(height: 1),
                              SwitchListTile(
                                secondary: const Icon(Icons.contrast_outlined),
                                title: Text(l.lightDarkMode),
                                thumbIcon: themeIcon,
                                value: setting?.lightmode ?? true,
                                onChanged: canModify && setting != null
                                    ? onThemeChange
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          _SettingsSectionHeading(
                            icon: Icons.manage_accounts_outlined,
                            title: l.dataAndAccount,
                          ),
                          const SizedBox(height: 10),
                          _SettingsPanel(
                            children: [
                              if (canModify) ...[
                                _SettingsActionTile(
                                  icon: Icons.delete_sweep_outlined,
                                  title: l.clearLocalData,
                                  onTap: _clearLocalData,
                                ),
                                const Divider(height: 1),
                              ],
                              _SettingsActionTile(
                                icon: Icons.logout,
                                title: l.logout,
                                color: colors.error,
                                onTap: _logout,
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          _SettingsSectionHeading(
                            icon: Icons.info_outline,
                            title: l.appInformation,
                          ),
                          const SizedBox(height: 10),
                          _SettingsPanel(
                            children: [
                              if (appInfo == null)
                                const Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else
                                AppInformationWidget(
                                  deviceId: appInfo!.deviceID,
                                  name: appInfo!.name,
                                  version: appInfo!.version,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _languageLabel(Locale locale) {
    return switch (locale.languageCode) {
      'de' => 'Deutsch',
      'en' => 'English',
      _ => locale.languageCode.toUpperCase(),
    };
  }

  Future<void> _clearLocalData() async {
    final l = Languages.of(context)!;
    if (!await RecipePermissions.canModifyContent() || !mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.clearLocalData),
        content: Text(l.confirmClearLocalData),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!kIsWeb) await AppUtil.deleteAllImages();
    await Singleton().getDatabase().deleteEverything();
    await KeyValue.resetKeyValues();
    logger.w('Deleted local data');
  }

  Future<void> _logout() async {
    final l = Languages.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.logout),
        content: Text(l.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.logout),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await AccountAuth.signOut(clearIdentity: false);
    } catch (error) {
      logger.e('Could not log out: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.somethingWentWrong)),
      );
      return;
    }
    logger.i('Logged out');
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      appReversePageRoute(
        builder: (context) => const LoginPage(),
        onTransitionCompleted: () async {
          await AccountAuth.clearLocalIdentity();
        },
      ),
      (route) => false,
    );
  }

  /// Saves a changed account setting locally and pushes it to the server.
  Future<void> _saveSetting(
    Future<void> Function(AppDatabase db, int accountId) update,
  ) async {
    final accountId = currentAccount;
    if (accountId == null) return;
    await update(Singleton().getDatabase(), accountId);
    SupabaseToDrift.sync();
  }

  Future<void> onLanguageChange(Locale? locale) async {
    if (locale == null || !await RecipePermissions.canModifyContent()) return;
    if (!mounted) return;
    RecipesApp.setLocale(context, Locale(locale.languageCode));
    await _saveSetting(
      (db, id) => db.updateAccountLanguage(id, locale.languageCode),
    );
  }

  Future<void> onRealtimeChange(bool enabled) async {
    if (!await RecipePermissions.canModifyContent()) return;
    await _saveSetting((db, id) => db.updateAccountRealtime(id, enabled));
  }

  Future<void> onThemeChange(bool lightMode) async {
    if (!await RecipePermissions.canModifyContent()) return;
    if (!mounted) return;
    RecipesApp.setTheme(context, lightMode ? ThemeMode.light : ThemeMode.dark);
    await _saveSetting((db, id) => db.updateAccountLightmode(id, lightMode));
  }
}

/// Lists app name, version and device id on the settings page.
class AppInformationWidget extends StatelessWidget {
  const AppInformationWidget({
    super.key,
    required this.name,
    required this.version,
    required this.deviceId,
  });

  final String name;
  final String version;
  final String deviceId;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Column(
      children: [
        _InformationRow(
          icon: Icons.fingerprint,
          label: l.deviceId,
          value: deviceId,
        ),
        const Divider(height: 1),
        _InformationRow(
          icon: Icons.info_outline,
          label: l.version,
          value: version,
        ),
      ],
    );
  }
}

class _SettingsSectionHeading extends StatelessWidget {
  const _SettingsSectionHeading({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 9),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String title;
  final Future<void> Function() onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.onSurface;
    return ListTile(
      leading: Icon(icon, color: effectiveColor),
      title: Text(title, style: TextStyle(color: effectiveColor)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelLarge),
                const SizedBox(height: 3),
                SelectableText(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
