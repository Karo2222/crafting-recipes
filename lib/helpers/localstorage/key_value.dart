import 'package:shared_preferences/shared_preferences.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/cancellation.dart';
import 'package:craftingrecipes/objects/singleton.dart';

/// Keys used in shared preferences.
///
/// The `sync_*` entries store the timestamp of the last successful download
/// of a table, so the next sync only fetches rows changed after it.
enum KeyValueEnum {
  // Identity
  currentAuthUser('current_auth_user'),
  currentAccount('current_account'),
  currentProfile('current_profile'),
  syncStatus('sync_status'),

  // Accounts and social
  role('sync_role'),
  setting('sync_setting'),
  account('sync_account'),
  profile('sync_profile'),
  accountFollow('sync_account_follow'),
  accountFriend('sync_account_friend'),
  chatConversation('sync_chat_conversation'),
  chatMessage('sync_chat_message'),
  chatMessageReaction('sync_chat_message_reaction'),

  // Recipes
  recipe('sync_recipe'),
  steps('sync_steps'),
  ingredient('sync_ingredient'),
  unit('sync_unit'),
  recipeIngredient('sync_recipe_ingredient'),
  recipeStepIngredient('sync_recipe_step_ingredient'),
  recipeLike('sync_recipe_like'),
  category('sync_category'),
  recipeCategory('sync_recipe_category'),
  comment('sync_comment'),
  history('sync_history'),

  // Planning
  shoppingList('sync_shopping_list'),
  shoppingListMember('sync_shopping_list_member'),
  shoppingListSection('sync_shopping_list_section'),
  shoppingListItem('sync_shopping_list_item'),
  shoppingCategory('sync_shopping_category'),
  mealPlan('sync_meal_plan'),
  mealPlanMember('sync_meal_plan_member'),
  mealPlanEntry('sync_meal_plan_entry'),
  mealPlanTemplate('sync_meal_plan_template'),
  mealPlanTemplateEntry('sync_meal_plan_template_entry');

  const KeyValueEnum(this.key);
  final String key;

  bool get isSyncTimestamp => key.startsWith('sync_') && this != syncStatus;
}

/// Thin wrapper around [SharedPreferences] for sync timestamps and identity.
class KeyValue {
  KeyValue._();

  /// Before the first sync every table is fetched from this point in time.
  static final String _initialTimestamp =
      DateTime(1900, 3, 1).toIso8601String();

  static Future<SharedPreferences> get _prefs => Singleton().getPrefInstance();

  /// Fills in missing sync timestamps and restores the sync status.
  static Future<void> initialize() async {
    final prefs = await _prefs;
    for (final entry in KeyValueEnum.values.where((e) => e.isSyncTimestamp)) {
      if (!prefs.containsKey(entry.key)) {
        await prefs.setString(entry.key, _initialTimestamp);
      }
    }
    // A sync that was interrupted by closing the app can be restarted manually.
    final stored = await getSyncStatus();
    await saveSyncStatus(
      stored == SyncStatus.runningSync
          ? SyncStatus.pendingSync
          : stored ?? SyncStatus.neverSynced,
    );
  }

  static Future<void> loadSyncStatus() async =>
      saveSyncStatus(await getSyncStatus() ?? SyncStatus.neverSynced);

  /// Clears all sync timestamps while keeping the signed-in identity.
  static Future<void> resetKeyValues() async {
    final prefs = await _prefs;
    final authUser = prefs.getString(KeyValueEnum.currentAuthUser.key);
    await prefs.clear();
    if (authUser != null) await setCurrentAuthUser(authUser);
    if (currentAccount != null) await setCurrentAccount(currentAccount!);
    if (currentProfile != null) await setCurrentProfile(currentProfile!);
    await initialize();
  }

  // Generic string values

  static Future<String?> getValue(String key) async =>
      (await _prefs).getString(key);

  static Future<void> setNewValue(String key, String value) async =>
      (await _prefs).setString(key, value);

  // Identity

  static Future<String?> getCurrentAuthUser() async =>
      (await _prefs).getString(KeyValueEnum.currentAuthUser.key);
  static Future<void> setCurrentAuthUser(String id) async =>
      (await _prefs).setString(KeyValueEnum.currentAuthUser.key, id);

  static Future<int?> getCurrentAccount() async =>
      (await _prefs).getInt(KeyValueEnum.currentAccount.key);
  static Future<void> setCurrentAccount(int id) async =>
      (await _prefs).setInt(KeyValueEnum.currentAccount.key, id);

  static Future<int?> getCurrentProfile() async =>
      (await _prefs).getInt(KeyValueEnum.currentProfile.key);
  static Future<void> setCurrentProfile(int id) async =>
      (await _prefs).setInt(KeyValueEnum.currentProfile.key, id);
  static Future<void> clearCurrentProfile() async =>
      (await _prefs).remove(KeyValueEnum.currentProfile.key);

  static Future<void> clearCurrentIdentity() async {
    final prefs = await _prefs;
    for (final entry in const [
      KeyValueEnum.currentAccount,
      KeyValueEnum.currentProfile,
      KeyValueEnum.currentAuthUser,
    ]) {
      await prefs.remove(entry.key);
    }
  }

  // Sync status

  static Future<SyncStatus?> getSyncStatus() async {
    final index = (await _prefs).getInt(KeyValueEnum.syncStatus.key);
    if (index == null || index < 0 || index >= SyncStatus.values.length) {
      return null;
    }
    return SyncStatus.values[index];
  }

  static Future<void> saveSyncStatus(SyncStatus status) async {
    await (await _prefs).setInt(KeyValueEnum.syncStatus.key, status.index);
    Singleton().setSyncStatus(newStatus: status);
  }
}
