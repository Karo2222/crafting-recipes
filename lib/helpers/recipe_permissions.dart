import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/helpers/localstorage/supabase_to_drift.dart';
import 'package:craftingrecipes/main.dart';
import 'package:craftingrecipes/objects/singleton.dart';

class RecipePermissions {
  static const String viewer = 'viewer';
  static const String editor = 'editor';
  static const String admin = 'admin';

  static Future<String> currentAccountRoleName() async {
    final accountId = currentAccount;
    if (accountId == null) return viewer;

    final database = Singleton().getDatabase();
    final accounts = await database.getAccountById(accountId);
    if (accounts.isNotEmpty) {
      final roles = await database.getRoleById(accounts.first.roleId);
      if (roles.isNotEmpty) return roles.first.name;
    }

    return await SupabaseToDrift.getAccountRoleName(accountId) ?? viewer;
  }

  static Future<String> currentProfileRoleName() async {
    final accountId = currentAccount;
    final profileId = currentProfile;
    if (accountId == null || profileId == null) return viewer;

    final cachedProfiles =
        await Singleton().getDatabase().getProfilesForAccount(accountId);
    final cachedProfile = cachedProfiles
        .where((profile) => profile['id'] == profileId)
        .firstOrNull;
    final cachedRole = cachedProfile?['role_name']?.toString().toLowerCase();
    if (cachedRole != null) return cachedRole;

    try {
      return (await SupabaseToDrift.getProfileRoleName(
            profileId: profileId,
            accountId: accountId,
          ))
              ?.toLowerCase() ??
          viewer;
    } catch (error) {
      logger.w('Could not load active profile role: $error');
      return viewer;
    }
  }

  static Future<bool> canModifyContent() async {
    final accountRole = await currentAccountRoleName();
    final profileRole = await currentProfileRoleName();
    return accountRoleCanModify(accountRole) &&
        profileRoleCanModify(profileRole);
  }

  static Stream<bool> watchCanModifyContent() {
    final accountId = currentAccount;
    final profileId = currentProfile;
    if (accountId == null || profileId == null) {
      return Stream.value(false);
    }
    return Singleton()
        .getDatabase()
        .watchContentRoleNames(accountId, profileId)
        .map((roles) =>
            accountRoleCanModify(roles.accountRole) &&
            profileRoleCanModify(roles.profileRole))
        .distinct();
  }

  static bool accountRoleCanModify(String? roleName) {
    final normalizedRole = roleName?.toLowerCase();
    return normalizedRole == editor || normalizedRole == admin;
  }

  static bool profileRoleCanModify(String? roleName) {
    final normalizedRole = roleName?.toLowerCase();
    return normalizedRole == editor || normalizedRole == admin;
  }

  static bool rolesCanCreateRecipe({
    required String? accountRoleName,
    required String? profileRoleName,
  }) {
    return accountRoleCanModify(accountRoleName) &&
        profileRoleCanModify(profileRoleName);
  }

  static Future<bool> canCreateRecipe() async {
    return rolesCanCreateRecipe(
      accountRoleName: await currentAccountRoleName(),
      profileRoleName: await currentProfileRoleName(),
    );
  }

  static Future<bool> canEditRecipe(Recipe recipe) async {
    final accountId = currentAccount;
    if (accountId == null) return false;
    if (!await canModifyContent()) return false;

    final roleName = await currentAccountRoleName();
    if (roleName == admin) return true;
    if (roleName == editor) return recipe.createdBy == accountId;
    return false;
  }

  static Stream<bool> watchCanEditRecipe(Recipe recipe) {
    final accountId = currentAccount;
    final profileId = currentProfile;
    if (accountId == null || profileId == null) {
      return Stream.value(false);
    }
    return Singleton()
        .getDatabase()
        .watchContentRoleNames(accountId, profileId)
        .map((roles) {
      if (!profileRoleCanModify(roles.profileRole)) return false;
      final accountRole = roles.accountRole?.toLowerCase();
      if (accountRole == admin) return true;
      return accountRole == editor && recipe.createdBy == accountId;
    }).distinct();
  }
}
