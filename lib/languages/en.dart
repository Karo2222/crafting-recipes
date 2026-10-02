import 'package:craftingrecipes/languages/languages.dart';

class LanguageEn extends Languages {
  @override
  String get languageCode => 'en';

  @override
  String get recipesTitle => "Recipes";

  @override
  String get recipe => "Recipe";

  @override
  String get openRecipe => "Open recipe";

  @override
  String get categorieButtonText => "Categories";

  @override
  String get cancel => "Cancel";

  @override
  String get delete => "Delete";

  @override
  String get description => "Description";
  @override
  String get recipeNotes => "Notes";
  @override
  String get recipeNotesHint =>
      "Add tips, substitutions, sources, or useful links";
  @override
  String get couldNotOpenLink => "Could not open this link";

  @override
  String get done => "Done";

  @override
  String get comments => "Comments";

  @override
  String get myComments => "My comments";

  @override
  String get addComment => "Add comment";

  @override
  String get editComment => "Edit comment";

  @override
  String get deleteComment => "Delete comment";

  @override
  String get commentActions => "Comment actions";

  @override
  String get commentContent => "Write a comment";

  @override
  String get commentSaved => "Comment saved.";

  @override
  String get noComments => "No comments yet.";

  @override
  String get historyTitle => "History";

  @override
  String get recipeSteps => "Recipe steps";

  @override
  String get startCooking => "Start cooking";

  @override
  String get allIngredients => "All ingredients";

  @override
  String get lastUpdate => "Last updated";

  @override
  String get createdAt => "Created";

  @override
  String get next => "Next";

  @override
  String get settingsTitle => "Settings";

  @override
  String get preferences => "Preferences";

  @override
  String get dataAndAccount => "Data & account";

  @override
  String get appInformation => "App information";

  @override
  String get clearLocalData => "Clear local data";

  @override
  String get confirmClearLocalData =>
      "This removes downloaded app data from this device. Continue?";

  @override
  String get step => "Step";

  @override
  String get steps => "Steps";

  @override
  String get pleaseEnterValue => "Please enter a value";

  @override
  String get search => "Search...";

  @override
  String get noRecipesAvailable => "No recipe steps available.";

  @override
  String get noHistoryAvailable => "No history available.";

  @override
  String get noImageAvailable => "No image available.";

  @override
  String get somethingWentWrong => "Something went wrong.";

  @override
  String get account => "Account";

  @override
  String get accounts => "Accounts";

  @override
  String get login => "Login";

  @override
  String get languages => "Languages";

  @override
  String get logout => "Logout";

  @override
  String get realtime => "Realtime";

  @override
  String get realtimeText => "Get changes directly in app when online";

  @override
  String get save => "Save";

  @override
  String get confirmCommentDelete =>
      "Are you sure you want to delete this comment?";

  @override
  String get confirm => "Confirm";

  @override
  String get createRecipe => "Create recipe";
  @override
  String get editRecipe => "Edit recipe";
  @override
  String get close => "Close";
  @override
  String get basics => "Basics";
  @override
  String get recipeImage => "Recipe image";
  @override
  String get addImage => "Add image";
  @override
  String get changeImage => "Change image";
  @override
  String get removeImage => "Remove image";
  @override
  String get chooseImageSource => "Choose image source";
  @override
  String get chooseFromGallery => "Choose from gallery";
  @override
  String get takePhoto => "Take photo";
  @override
  String get imageSelectionFailed => "The image could not be selected.";
  @override
  String get ingredient => "Ingredient";
  @override
  String get ingredients => "Ingredients";
  @override
  String get addIngredient => "Add ingredient";
  @override
  String get addIngredientSection => "Add ingredient section";
  @override
  String get ingredientSection => "Section";
  @override
  String get ingredientSectionName => "Section name";
  @override
  String ingredientSectionNameAlreadyExists(String name) =>
      'An ingredient section named "$name" already exists.';
  @override
  String get noIngredientSection => "No section";
  @override
  String get renameIngredientSection => "Rename ingredient section";
  @override
  String get removeIngredientSection => "Remove ingredient section";
  @override
  String confirmRemoveIngredientSection(String name) =>
      'Remove "$name"? Its ingredients will remain without a section.';
  @override
  String get reorderIngredient => "Reorder ingredient";
  @override
  String get editIngredient => "Edit ingredient";
  @override
  String get removeIngredient => "Remove ingredient";
  @override
  String get noIngredientsAdded => "No ingredients added yet.";
  @override
  String get addStep => "Add step";
  @override
  String get editStep => "Edit step";
  @override
  String get removeStep => "Remove step";
  @override
  String get noStepsAdded => "No steps added yet.";
  @override
  String get recipeTitle => "Recipe title";
  @override
  String get recipeTitleRequired => "Recipe title is required";
  @override
  String get totalTime => "Total time";
  @override
  String get totalTimeMinutes => "Total time (minutes)";
  @override
  String get invalidTotalTime => "Enter a whole number above 0";
  @override
  String get createdBy => "Created by";
  @override
  String get notSpecified => "Not specified";
  @override
  String get unsavedChanges => "Unsaved changes";
  @override
  String get discard => "Discard";
  @override
  String get discardChanges => "Discard changes?";
  @override
  String get discardChangesMessage =>
      "Any changes you made on this recipe will be lost.";
  @override
  String get discardMealChangesMessage =>
      "All changes to this meal-plan entry will be lost.";
  @override
  String get keepEditing => "Keep editing";
  @override
  String get saveChanges => "Save changes";
  @override
  String get saveRecipe => "Save recipe";
  @override
  String get recipeSaveRequirements =>
      "Add a title, one complete ingredient, and one step to save.";
  @override
  String get completeIngredientRequired =>
      "Add at least one complete ingredient.";
  @override
  String get ingredientName => "Ingredient name";
  @override
  String get ingredientNameRequired => "Ingredient name is required";
  @override
  String get amount => "Amount";
  @override
  String get optionalAmount => "Amount (optional)";
  @override
  String get amountRequired => "Amount is required";
  @override
  String get invalidAmount => "Use a number, for example 1.5";
  @override
  String get amountAboveZero => "Amount must be above 0";
  @override
  String get unit => "Unit";
  @override
  String get optionalUnit => "Unit (optional)";
  @override
  String get unitRequired => "Unit is required";
  @override
  String get noUnitsAvailable => "No units available";
  @override
  String get ingredientQuantityNote => "Quantity note (optional)";
  @override
  String get ingredientQuantityNoteHint => "For example: to taste or as needed";
  @override
  String get quantityNotSpecified => "Quantity not specified";
  @override
  String get stepInstruction => "What needs to be done?";
  @override
  String get stepTextRequired => "Step text is required";
  @override
  String get ingredientsInStep => "Ingredients in this step";
  @override
  String get addIngredientsFirst => "Add ingredients before selecting them.";
  @override
  String get noIngredientsAssigned => "No ingredients assigned";
  @override
  String get more => "more";
  @override
  String get newRecipe => "New recipe";
  @override
  String get noRecipeSelected => "No recipe selected!";
  @override
  String get noMatchingRecipes => "No matching recipes";
  @override
  String get noRecipesYet => "No recipes yet";
  @override
  String get createFirstRecipe => "Create your first recipe";
  @override
  String get profiles => "Profiles";
  @override
  String get createProfile => "Create profile";
  @override
  String get profileName => "Profile name";
  @override
  String get profilePermission => "Profile permission";
  @override
  String get enterProfileName => "Please enter a profile name.";
  @override
  String get couldNotCreateProfile => "Could not create profile.";
  @override
  String get deleteProfile => "Delete profile";
  @override
  String get lastProfileCannotBeDeleted => "At least one profile must remain.";
  @override
  String get couldNotDeleteProfile => "Could not delete profile.";
  @override
  String get couldNotUpdateProfilePermission =>
      "Could not update profile permission.";
  @override
  String get shoppingLists => "Shopping lists";
  @override
  String get mealPlan => "Meal plan";
  @override
  String get renameMealPlan => "Rename meal plan";
  @override
  String get deleteMealPlan => "Delete meal plan";
  @override
  String get servings => "Servings";
  @override
  String get decreaseServings => "Decrease servings";
  @override
  String get increaseServings => "Increase servings";
  @override
  String get recipeServings => "Default servings (optional)";
  @override
  String get plannedServings => "Planned servings (optional)";
  @override
  String get invalidServings => "Enter a whole number above 0";
  @override
  String get scaleIngredients => "Scale ingredient";
  @override
  String get mealPlanActions => "Meal-plan actions";
  @override
  String get copyPreviousWeek => "Copy previous week";
  @override
  String get copyPreviousWeekDescription =>
      "Copy all meals from the previous week into this week.";
  @override
  String get replaceCurrentWeek => "Replace this week";
  @override
  String get addToCurrentWeek => "Add to this week";
  @override
  String get weekCopied => "The previous week was copied.";
  @override
  String get saveWeekAsTemplate => "Save week as template";
  @override
  String get templateName => "Template name";
  @override
  String get mealPlanTemplates => "Meal-plan templates";
  @override
  String get noMealPlanTemplates => "No templates saved yet.";
  @override
  String get noMealPlanTemplatesDescription =>
      "Save a week as a template to reuse its meals later.";
  @override
  String get applyMeals => "Apply meals";
  @override
  String get savedTemplates => "Saved templates";
  @override
  String get renameTemplate => "Rename template";
  @override
  String get previewTemplate => "Preview template";
  @override
  String get emptyWeekCannotBeSaved =>
      "Add at least one meal before saving this week as a template.";
  @override
  String get noMealsToApply => "There are no meals to apply.";
  @override
  String get applyTemplate => "Apply template";
  @override
  String get applyTemplateDescription =>
      "Choose whether the template should replace or extend this week.";
  @override
  String get deleteTemplate => "Delete template";
  @override
  String get templateSaved => "Template saved.";
  @override
  String get templateApplied => "Template applied.";
  @override
  String get couldNotManageMealPlan =>
      "The meal-plan operation could not be completed.";
  @override
  String get today => "Today";
  @override
  String get openFullWeek => "Open full week";
  @override
  String get noMealsPlanned => "No meals planned";
  @override
  String get previousWeek => "Previous week";
  @override
  String get nextWeek => "Next week";
  @override
  String get breakfast => "Breakfast";
  @override
  String get lunch => "Lunch";
  @override
  String get dinner => "Dinner";
  @override
  String get snack => "Snack";
  @override
  String get addMeal => "Add meal";
  @override
  String get editMeal => "Edit meal";
  @override
  String get recipeMeal => "Recipe";
  @override
  String get customMeal => "Custom";
  @override
  String get selectRecipe => "Select a recipe";
  @override
  String get searchRecipes => "Search";
  @override
  String get ownRecipes => "Own recipes";
  @override
  String get likedRecipes => "Liked recipes";
  @override
  String get noLikedRecipes => "No liked recipes yet";
  @override
  String get likeRecipe => "Like recipe";
  @override
  String get unlikeRecipe => "Unlike recipe";
  @override
  String get couldNotUpdateLike => "Could not update the recipe like.";
  @override
  String get selectCategories => "Select categories";
  @override
  String get selectedCategories => "Categories";
  @override
  String get clearSelection => "Clear";
  @override
  String get apply => "Apply";
  @override
  String get customMealTitle => "Meal title";
  @override
  String get mealNote => "Note (optional)";
  @override
  String get deleteMeal => "Delete meal";
  @override
  String get couldNotSaveMeal => "Could not save the meal plan.";
  @override
  String get shoppingList => "Shopping list";
  @override
  String get createShoppingList => "Create shopping list";
  @override
  String get shoppingListName => "List name";
  @override
  String get noShoppingLists => "No shopping lists yet";
  @override
  String get createFirstShoppingList => "Create your first shopping list";
  @override
  String get renameShoppingList => "Rename shopping list";
  @override
  String get deleteShoppingList => "Delete shopping list";
  @override
  String get shoppingItems => "Shopping items";
  @override
  String get shoppingSections => "Store sections";
  @override
  String get generalShoppingSection => "General";
  @override
  String get addShoppingSection => "Add store section";
  @override
  String get renameShoppingSection => "Rename store section";
  @override
  String get deleteShoppingSection => "Delete store section";
  @override
  String get shoppingSectionName => "Store or section name";
  @override
  String get moveToShoppingSection => "Move to section";
  @override
  String collapseShoppingSection(String name) => 'Collapse "$name"';
  @override
  String expandShoppingSection(String name) => 'Expand "$name"';
  @override
  String get dropShoppingItemHere => "Drop item here";
  @override
  String get couldNotSaveShoppingSection => "Could not save store section.";
  @override
  String shoppingSectionNameAlreadyExists(String name) =>
      "This name is already in use.";
  @override
  String get detailedShoppingList => "Detailed";
  @override
  String get quickShoppingList => "Quick add";
  @override
  String get quickAddShoppingItem => "Add an item";
  @override
  String get addShoppingItem => "Add shopping item";
  @override
  String get editShoppingItem => "Edit shopping item";
  @override
  String get shoppingItemName => "Item name";
  @override
  String get shoppingItemNote => "Note (optional)";
  @override
  String get optionalQuantity => "Quantity (optional)";
  @override
  String get noShoppingItems => "This shopping list is empty";
  @override
  String get addToShoppingList => "Add to shopping list";
  @override
  String get chooseShoppingList => "Choose a shopping list";
  @override
  String get removeShoppingItem => "Remove shopping item";
  @override
  String removeCheckedShoppingItems(int count) => "Clear checked ($count)";
  @override
  String confirmRemoveCheckedShoppingItems(int count) =>
      "Remove all $count checked shopping items?";
  @override
  String confirmDeleteShoppingSection(String name) =>
      'Delete "$name"? Its items will move to General.';
  @override
  String get couldNotSaveShoppingList => "Could not save shopping list.";
  @override
  String get couldNotSaveShoppingItem => "Could not save shopping item.";
  @override
  String get supermarketCategory => "Supermarket category";
  @override
  String get create => "Create";
  @override
  String get scanner => "Scanner";
  @override
  String get sync => "Sync";
  @override
  String get database => "Database";
  @override
  String get cancelSync => "Cancel sync";
  @override
  String get startSync => "Start sync";
  @override
  String get syncProgress => "Sync progress";
  @override
  String get lastSyncError => "Last sync error";
  @override
  String get neverSynced => "Never synced";
  @override
  String get pendingSync => "Pending sync";
  @override
  String get fullSync => "Fully synced";
  @override
  String get runningSync => "Syncing";
  @override
  String get cancelledSync => "Sync cancelled";
  @override
  String get lightDarkMode => "Light mode / Dark mode";
  @override
  String get deviceId => "Device ID";
  @override
  String get version => "Version";
  @override
  String get registrationPage => "Registration";
  @override
  String get accountName => "Account name";
  @override
  String get accountNotAvailable => "This account is not available.";
  @override
  String get editAccount => "Edit account";
  @override
  String get bio => "About";
  @override
  String get bioHint => "Tell people a little about yourself";
  @override
  String get noBioYet => "No account description yet.";
  @override
  String get memberSince => "Member since";
  @override
  String get followers => "followers";
  @override
  String get following => "following";
  @override
  String get follow => "Follow";
  @override
  String get chooseAccountImage => "Choose photo";
  @override
  String get couldNotUpdateAccount => "Could not update account";
  @override
  String get email => "Email";
  @override
  String get password => "Password";
  @override
  String get confirmPassword => "Confirm password";
  @override
  String get showPassword => "Show password";
  @override
  String get hidePassword => "Hide password";
  @override
  String get passwordTooShort => "Password must contain at least 8 characters.";
  @override
  String get passwordsDoNotMatch => "The passwords do not match.";
  @override
  String get hostCode => "Host code";
  @override
  String get createAccount => "Create account";
  @override
  String get alreadyHaveAccount => "Already have an account? Log in";
  @override
  String get fillAllFields => "Please fill in all fields.";
  @override
  String get invalidHostCode => "Invalid host code.";
  @override
  String get emailAlreadyExists => "Email already exists.";
  @override
  String get couldNotIdentifyDevice => "Could not identify this device.";
  @override
  String get accountNameAlreadyExists => "Account name already exists.";
  @override
  String get registrationFailed => "Could not complete registration.";
  @override
  String get enterEmailAndPassword => "Please enter email and password.";
  @override
  String get invalidEmailOrPassword => "Email or password is incorrect.";
  @override
  String get accountNotLinked =>
      "This login is not linked to an app account yet.";
  @override
  String get verifyEmailBeforeLogin =>
      "Check your email to confirm the account, then log in.";
  @override
  String get resendConfirmationEmail => "Resend confirmation email";
  @override
  String get confirmationEmailSent =>
      "A new confirmation email has been sent. Check your inbox.";
  @override
  String get emailAlreadyConfirmed =>
      "This email is already confirmed. You can log in.";
  @override
  String get enterValidEmail => "Please enter a valid email address.";
  @override
  String get confirmationEmailRateLimited =>
      "Please wait before requesting another confirmation email.";
  @override
  String get confirmationEmailCouldNotBeSent =>
      "The confirmation email could not be sent.";
  @override
  String get noMainProfile => "No main profile found.";
  @override
  String get couldNotLogIn => "Could not log in.";
  @override
  String get codeScanner => "Code scanner";
  @override
  String get recipeAssets => "Recipe assets";
  @override
  String get noHistorySelected => "No history entry selected!";
  @override
  String get emptyData => "No data available.";
  @override
  String get noCategoriesAvailable => "No categories available";
  @override
  String get viewerCannotEdit => "Viewer profiles cannot make changes.";
  @override
  String get manageAccess => "Manage access";
  @override
  String get addPerson => "Add person";
  @override
  String get sharedWith => "Shared with";
  @override
  String get owner => "Owner";
  @override
  String get noSharedMembers => "Not shared with anyone yet.";
  @override
  String get removeAccess => "Remove access";
  @override
  String get createMealPlan => "Create meal plan";
  @override
  String get mealPlanName => "Meal-plan name";
  @override
  String get searchAccounts => "Search accounts";
  @override
  String get searchFriends => "Search friends";
  @override
  String get suggestions => "Suggestions";
  @override
  String get findPeople => "Find people";
  @override
  String get chat => "Chat";
  @override
  String get conversations => "Conversations";
  @override
  String get newConversation => "New conversation";
  @override
  String get noConversations => "No conversations yet.";
  @override
  String get noFriendsToChat => "Add a friend before starting a conversation.";
  @override
  String get startChat => "Start chat";
  @override
  String get couldNotLoadMessages => "Messages could not be loaded.";
  @override
  String get tryAgain => "Try again";
  @override
  String get messageHint => "Message";
  @override
  String get sendMessage => "Send message";
  @override
  String get addAttachment => "Add attachment";
  @override
  String get removeAttachment => "Remove attachment";
  @override
  String get shareRecipe => "Share recipe";
  @override
  String get sharedRecipe => "Shared recipe";
  @override
  String get recipeUnavailable => "Recipe no longer available";
  @override
  String get recipeDetailsNotReady =>
      "The recipe details are still loading. Please try again.";
  @override
  String get shareShoppingList => "Share shopping list";
  @override
  String get sharedShoppingList => "Shared shopping list";
  @override
  String get shoppingListUnavailable => "Shopping list no longer available";
  @override
  String get noShoppingListsAvailableToShare =>
      "No shopping lists are currently shared with this person.";
  @override
  String get jumpToLatest => "Jump to newest message";
  @override
  String get replyingTo => "Replying to";
  @override
  String get removeReply => "Cancel reply";
  @override
  String get originalMessageUnavailable => "Original message unavailable";
  @override
  String get reactToMessage => "React to message";
  @override
  String get accountFound => "Account found";
  @override
  String get accountNotFound => "No matching account found";
  @override
  String get sendInvitation => "Send invitation";
  @override
  String get invitationPending => "Invitation pending";
  @override
  String get invitations => "Invitations";
  @override
  String get noPendingInvitations => "No pending invitations.";
  @override
  String get invitedBy => "Invited by";
  @override
  String get acceptInvitation => "Accept";
  @override
  String get declineInvitation => "Decline";
  @override
  String get friends => "Friends";
  @override
  String get friendRequests => "Friend requests";
  @override
  String get addFriend => "Add friend";
  @override
  String get friendRequestSent => "Request sent";
  @override
  String get removeFriend => "Remove friend";
  @override
  String get confirmLogout => "Are you sure you want to log out?";
  @override
  String get noFriends => "No friends yet.";
  @override
  String get onlyFriendsCanBeInvited => "Only accepted friends can be invited.";
  @override
  String get invalidScannedCode => "The scanned code is incomplete or invalid.";
  @override
  String get couldNotCreateRecipe => "Could not create recipe";
  @override
  String get couldNotUpdateRecipe => "Could not update recipe";
  @override
  String get compareRecipeChanges => "Compare recipe changes";
  @override
  String get recipeComparisonMessage =>
      "The recipe changed after you opened the editor. Review both versions before deciding what to keep.";
  @override
  String get yourVersion => "Your version";
  @override
  String get latestVersion => "Latest database version";
  @override
  String get useLatestVersion => "Use latest version";
  @override
  String get changed => "Changed";
  @override
  String get couldNotCompareRecipe =>
      "Could not load the database version. Your edits are still here.";
  @override
  String get recipeDeletedTitle => "Recipe was deleted";
  @override
  String get recipeDeletedRemotely =>
      "This recipe was deleted on another device. You can keep your edits open or save your version as a new recipe.";
  @override
  String get saveAsCopy => "Save as copy";
  @override
  String get recipeSavedAsCopy => "Your version was saved as a new recipe.";
  @override
  String get couldNotLoadLatestRecipe =>
      "Could not load the latest recipe. Your edits are still here.";

  @override
  String recipeCopyTitle(String title) => "$title (copy)";

  @override
  String confirmRemoveFromRecipe(String name) =>
      'Do you really want to delete "$name" from this recipe?';

  @override
  String confirmDeleteProfile(String name) =>
      'Delete the profile "$name"? This cannot be undone.';

  @override
  String confirmDeleteShoppingList(String name) =>
      'Delete "$name" and all of its items? This cannot be undone.';

  @override
  String confirmDeleteMealPlan(String name) =>
      'Delete "$name" and all of its planned meals? This cannot be undone.';

  @override
  String confirmDeleteTemplate(String name) =>
      'Delete the template "$name"? This cannot be undone.';

  @override
  String confirmRemoveShoppingItem(String name) =>
      'Remove "$name" from this shopping list?';

  @override
  String confirmDeleteMeal(String title) =>
      'Delete "$title" from the meal plan?';

  @override
  String confirmRemoveFriend(String accountName) =>
      'Remove "$accountName" from your friends? Access to meal plans and shopping lists shared between you will also be removed.';

  @override
  String confirmRemoveAccess(String accountName, String resourceName) =>
      'Remove "$accountName" from "$resourceName"? They will lose access to it.';

  @override
  String addedToShoppingList(String name) => 'Added to "$name".';

  @override
  String scaledAmount(String amount) => "Shopping-list amount: $amount";

  @override
  String mealCount(int count) => count == 1 ? "1 meal" : "$count meals";

  @override
  String stepCount(int count) => count == 1 ? "1 step" : "$count steps";

  @override
  String roleLabel(String roleName) => roleName;

  @override
  String syncTableLabel(String tableName) => tableName;

  @override
  String syncMutationLabel(String mutationType) {
    const labels = {
      'shopping_list_upsert': 'Shopping list',
      'shopping_list_item_upsert': 'Shopping-list item',
      'shopping_list_member_upsert': 'Shopping-list sharing',
      'shopping_list_invitation_response': 'Shopping-list invitation',
      'meal_plan_upsert': 'Meal plan',
      'meal_plan_entry_upsert': 'Meal-plan entry',
      'meal_plan_member_upsert': 'Meal-plan sharing',
      'meal_plan_invitation_response': 'Meal-plan invitation',
      'meal_plan_template_upsert': 'Meal-plan template',
      'meal_plan_template_entry_upsert': 'Meal-plan template entry',
      'recipe_create': 'New recipe',
      'recipe_update': 'Recipe changes',
      'ingredient_category_update': 'Ingredient category',
      'account_friend_request': 'Friend request',
      'account_friend_response': 'Friend-request response',
      'account_friend_remove': 'Removing friend',
      'chat_message_send': 'Chat message',
      'chat_messages_read': 'Read-message status',
      'chat_reaction_set': 'Message reaction',
    };
    return labels[mutationType] ?? mutationType;
  }

  @override
  String syncUploadFailed(String change) => '$change could not be uploaded.';

  @override
  String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours == 0) return '$remainingMinutes min';
    if (remainingMinutes == 0) return '$hours hr';
    return '$hours hr $remainingMinutes min';
  }

  @override
  String unitLabel(String unitCode) {
    const labels = {
      'fl_oz': 'fl oz',
    };
    return labels[unitCode] ?? unitCode;
  }
}
