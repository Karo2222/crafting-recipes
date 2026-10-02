/// Column names used when reading Supabase rows, plus a few local keys.
enum Const {
  // Audit columns shared by most tables
  id('id'),
  createdAt('created_at'),
  createdBy('created_by'),
  updatedAt('updated_at'),
  updatedBy('updated_by'),
  deletedAt('deleted_at'),
  deletedBy('deleted_by'),
  revision('revision'),

  // Accounts, profiles and roles
  accountId('account_id'),
  profileId('profile_id'),
  accountName('account_name'),
  profileImage('profile_image'),
  bio('bio'),
  email('email'),
  roleId('role_id'),
  roleName('role_name'),
  permission('permission'),
  followerAccountId('follower_account_id'),
  followedAccountId('followed_account_id'),
  firstAccountId('first_account_id'),
  secondAccountId('second_account_id'),
  requestedBy('requested_by'),
  invitationStatus('status'),

  // Recipes
  recipeId('recipe_id'),
  recipeStepId('recipe_step_id'),
  ingredientId('ingredient_id'),
  categoryId('category_id'),
  title('title'),
  name('name'),
  description('description'),
  notes('notes'),
  image('image'),
  stepNr('step_nr'),
  amount('amount'),
  unit('unit'),
  quantityNote('quantity_note'),
  sectionId('section_id'),
  sectionName('section_name'),
  totalTimeMinutes('total_time_minutes'),
  selectable('selectable'),
  realtime('realtime'),
  open('open'),
  additionalData('additional_data'),

  // Units and shopping categories
  code('code'),
  nameEn('name_en'),
  nameDe('name_de'),
  sortOrder('sort_order'),

  // Meal plans and shopping lists
  mealPlanId('meal_plan_id'),
  shoppingListId('shopping_list_id'),
  shoppingCategoryCode('shopping_category_code'),
  plannedDate('planned_date'),
  mealSlot('meal_slot'),
  servings('servings'),
  templateId('template_id'),
  dayOffset('day_offset'),
  customTitle('custom_title'),
  checked('checked'),
  note('note'),

  // Chat
  senderAccountId('sender_account_id'),
  message('message'),
  reaction('reaction'),
  replyToMessageId('reply_to_message_id'),
  replyMessageSnapshot('reply_message_snapshot'),
  recipeTitleSnapshot('recipe_title_snapshot'),
  shoppingListNameSnapshot('shopping_list_name_snapshot'),

  // Settings
  language('language'),
  lightmode('lightmode'),

  // Local media cache folders (inside the app's documents directory)
  imagesFolderName('craftingrecipes/images'),
  recipeImagesFolderName('craftingrecipes/images/recipeImages'),
  recipeStepsImagesFolderName('craftingrecipes/images/recipeStepsImages'),

  // Field of the JSON payload encoded in sharing QR codes
  hostCode('host_code');

  const Const(this.key);
  final String key;
}
