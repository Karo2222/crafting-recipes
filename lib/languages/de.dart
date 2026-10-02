import 'package:craftingrecipes/languages/languages.dart';

class LanguageDe extends Languages {
  @override
  String get languageCode => 'de';

  @override
  String get recipesTitle => "Rezepte";

  @override
  String get recipe => "Rezept";

  @override
  String get openRecipe => "Rezept öffnen";

  @override
  String get categorieButtonText => "Kategorien";

  @override
  String get cancel => "Abbrechen";

  @override
  String get delete => "Löschen";

  @override
  String get description => "Beschreibung";
  @override
  String get recipeNotes => "Notizen";
  @override
  String get recipeNotesHint =>
      "Tipps, Alternativen, Quellen oder nützliche Links hinzufügen";
  @override
  String get couldNotOpenLink => "Dieser Link konnte nicht geöffnet werden";

  @override
  String get done => "Fertig";

  @override
  String get comments => "Kommentare";

  @override
  String get myComments => "Meine Kommentare";

  @override
  String get addComment => "Kommentar hinzufügen";

  @override
  String get editComment => "Kommentar bearbeiten";

  @override
  String get deleteComment => "Kommentar löschen";

  @override
  String get commentActions => "Kommentaraktionen";

  @override
  String get commentContent => "Schreibe einen Kommentar";

  @override
  String get commentSaved => "Kommentar gespeichert.";

  @override
  String get noComments => "Noch keine Kommentare.";

  @override
  String get historyTitle => "Verlauf";

  @override
  String get recipeSteps => "Rezeptschritte";

  @override
  String get startCooking => "Kochen starten";

  @override
  String get allIngredients => "Alle Zutaten";

  @override
  String get lastUpdate => "Zuletzt geändert";

  @override
  String get createdAt => "Erstellt";

  @override
  String get next => "Weiter";

  @override
  String get settingsTitle => "Einstellungen";

  @override
  String get preferences => "Präferenzen";

  @override
  String get dataAndAccount => "Daten & Konto";

  @override
  String get appInformation => "App-Informationen";

  @override
  String get clearLocalData => "Lokale Daten löschen";

  @override
  String get confirmClearLocalData =>
      "Dadurch werden heruntergeladene App-Daten von diesem Gerät entfernt. Fortfahren?";

  @override
  String get step => "Schritt";

  @override
  String get steps => "Schritte";

  @override
  String get pleaseEnterValue => "Bitte gib etwas ein";

  @override
  String get search => "Suchen...";

  @override
  String get noRecipesAvailable => "Keine Rezeptschritte verfügbar.";

  @override
  String get noHistoryAvailable => "Kein Verlauf verfügbar.";

  @override
  String get noImageAvailable => "Kein Bild verfügbar.";

  @override
  String get somethingWentWrong => "Etwas ist schiefgelaufen.";

  @override
  String get account => "Konto";

  @override
  String get accounts => "Konten";

  @override
  String get login => "Anmelden";

  @override
  String get languages => "Sprachen";

  @override
  String get logout => "Abmelden";

  @override
  String get realtime => "Realtime";

  @override
  String get realtimeText =>
      "Erhalten Sie Änderungen direkt in der App, wenn Sie online sind.";

  @override
  String get save => "Speichern";

  @override
  String get confirmCommentDelete =>
      "Soll dieser Kommentar wirklich gelöscht werden?";

  @override
  String get confirm => "Bestätigen";

  @override
  String get createRecipe => "Rezept erstellen";
  @override
  String get editRecipe => "Rezept bearbeiten";
  @override
  String get close => "Schließen";
  @override
  String get basics => "Grundlagen";
  @override
  String get recipeImage => "Rezeptbild";
  @override
  String get addImage => "Bild hinzufügen";
  @override
  String get changeImage => "Bild ändern";
  @override
  String get removeImage => "Bild entfernen";
  @override
  String get chooseImageSource => "Bildquelle auswählen";
  @override
  String get chooseFromGallery => "Aus Galerie auswählen";
  @override
  String get takePhoto => "Foto aufnehmen";
  @override
  String get imageSelectionFailed => "Das Bild konnte nicht ausgewählt werden.";
  @override
  String get ingredient => "Zutat";
  @override
  String get ingredients => "Zutaten";
  @override
  String get addIngredient => "Zutat hinzufügen";
  @override
  String get addIngredientSection => "Zutatenbereich hinzufügen";
  @override
  String get ingredientSection => "Bereich";
  @override
  String get ingredientSectionName => "Name des Bereichs";
  @override
  String ingredientSectionNameAlreadyExists(String name) =>
      'Ein Zutatenbereich namens "$name" existiert bereits.';
  @override
  String get noIngredientSection => "Ohne Bereich";
  @override
  String get renameIngredientSection => "Zutatenbereich umbenennen";
  @override
  String get removeIngredientSection => "Zutatenbereich entfernen";
  @override
  String confirmRemoveIngredientSection(String name) =>
      '"$name" entfernen? Die Zutaten bleiben ohne Bereich erhalten.';
  @override
  String get reorderIngredient => "Zutat verschieben";
  @override
  String get editIngredient => "Zutat bearbeiten";
  @override
  String get removeIngredient => "Zutat entfernen";
  @override
  String get noIngredientsAdded => "Noch keine Zutaten hinzugefügt.";
  @override
  String get addStep => "Schritt hinzufügen";
  @override
  String get editStep => "Schritt bearbeiten";
  @override
  String get removeStep => "Schritt entfernen";
  @override
  String get noStepsAdded => "Noch keine Schritte hinzugefügt.";
  @override
  String get recipeTitle => "Rezepttitel";
  @override
  String get recipeTitleRequired => "Ein Rezepttitel ist erforderlich";
  @override
  String get totalTime => "Gesamtzeit";
  @override
  String get totalTimeMinutes => "Gesamtzeit (Minuten)";
  @override
  String get invalidTotalTime => "Gib eine ganze Zahl größer als 0 ein";
  @override
  String get createdBy => "Erstellt von";
  @override
  String get notSpecified => "Nicht angegeben";
  @override
  String get unsavedChanges => "Ungespeicherte Änderungen";
  @override
  String get discard => "Verwerfen";
  @override
  String get discardChanges => "Änderungen verwerfen?";
  @override
  String get discardChangesMessage =>
      "Alle Änderungen an diesem Rezept gehen verloren.";
  @override
  String get discardMealChangesMessage =>
      "Alle Änderungen an diesem Essensplaneintrag gehen verloren.";
  @override
  String get keepEditing => "Weiter bearbeiten";
  @override
  String get saveChanges => "Änderungen speichern";
  @override
  String get saveRecipe => "Rezept speichern";
  @override
  String get recipeSaveRequirements =>
      "Füge einen Titel, eine vollständige Zutat und einen Schritt hinzu.";
  @override
  String get completeIngredientRequired =>
      "Füge mindestens eine vollständige Zutat hinzu.";
  @override
  String get ingredientName => "Name der Zutat";
  @override
  String get ingredientNameRequired => "Der Name der Zutat ist erforderlich";
  @override
  String get amount => "Menge";
  @override
  String get optionalAmount => "Menge (optional)";
  @override
  String get amountRequired => "Eine Menge ist erforderlich";
  @override
  String get invalidAmount => "Verwende eine Zahl, zum Beispiel 1,5";
  @override
  String get amountAboveZero => "Die Menge muss größer als 0 sein";
  @override
  String get unit => "Einheit";
  @override
  String get optionalUnit => "Einheit (optional)";
  @override
  String get unitRequired => "Eine Einheit ist erforderlich";
  @override
  String get noUnitsAvailable => "Keine Einheiten verfügbar";
  @override
  String get ingredientQuantityNote => "Mengenhinweis (optional)";
  @override
  String get ingredientQuantityNoteHint =>
      "Zum Beispiel: nach Geschmack oder nach Bedarf";
  @override
  String get quantityNotSpecified => "Menge nicht angegeben";
  @override
  String get stepInstruction => "Was muss gemacht werden?";
  @override
  String get stepTextRequired =>
      "Eine Beschreibung des Schritts ist erforderlich";
  @override
  String get ingredientsInStep => "Zutaten in diesem Schritt";
  @override
  String get addIngredientsFirst =>
      "Füge zuerst Zutaten hinzu, um sie auswählen zu können.";
  @override
  String get noIngredientsAssigned => "Keine Zutaten zugewiesen";
  @override
  String get more => "weitere";
  @override
  String get newRecipe => "Neues Rezept";
  @override
  String get noRecipeSelected => "Kein Rezept ausgewählt!";
  @override
  String get noMatchingRecipes => "Keine passenden Rezepte";
  @override
  String get noRecipesYet => "Noch keine Rezepte";
  @override
  String get createFirstRecipe => "Erstes Rezept erstellen";
  @override
  String get profiles => "Profile";
  @override
  String get createProfile => "Profil erstellen";
  @override
  String get profileName => "Profilname";
  @override
  String get profilePermission => "Profilberechtigung";
  @override
  String get enterProfileName => "Bitte gib einen Profilnamen ein.";
  @override
  String get couldNotCreateProfile =>
      "Das Profil konnte nicht erstellt werden.";
  @override
  String get deleteProfile => "Profil löschen";
  @override
  String get lastProfileCannotBeDeleted =>
      "Mindestens ein Profil muss bestehen bleiben.";
  @override
  String get couldNotDeleteProfile =>
      "Das Profil konnte nicht gelöscht werden.";
  @override
  String get couldNotUpdateProfilePermission =>
      "Die Profilberechtigung konnte nicht geändert werden.";
  @override
  String get shoppingLists => "Einkaufslisten";
  @override
  String get mealPlan => "Essensplan";
  @override
  String get renameMealPlan => "Essensplan umbenennen";
  @override
  String get deleteMealPlan => "Essensplan löschen";
  @override
  String get servings => "Portionen";
  @override
  String get decreaseServings => "Portionen verringern";
  @override
  String get increaseServings => "Portionen erhöhen";
  @override
  String get recipeServings => "Standardportionen (optional)";
  @override
  String get plannedServings => "Geplante Portionen (optional)";
  @override
  String get invalidServings => "Gib eine ganze Zahl größer als 0 ein";
  @override
  String get scaleIngredients => "Zutat skalieren";
  @override
  String get mealPlanActions => "Essensplan-Aktionen";
  @override
  String get copyPreviousWeek => "Vorherige Woche kopieren";
  @override
  String get copyPreviousWeekDescription =>
      "Alle Mahlzeiten der vorherigen Woche in diese Woche kopieren.";
  @override
  String get replaceCurrentWeek => "Diese Woche ersetzen";
  @override
  String get addToCurrentWeek => "Zu dieser Woche hinzufügen";
  @override
  String get weekCopied => "Die vorherige Woche wurde kopiert.";
  @override
  String get saveWeekAsTemplate => "Woche als Vorlage speichern";
  @override
  String get templateName => "Vorlagenname";
  @override
  String get mealPlanTemplates => "Essensplan-Vorlagen";
  @override
  String get noMealPlanTemplates => "Noch keine Vorlagen gespeichert.";
  @override
  String get noMealPlanTemplatesDescription =>
      "Speichere eine Woche als Vorlage, um ihre Mahlzeiten wiederzuverwenden.";
  @override
  String get applyMeals => "Mahlzeiten übernehmen";
  @override
  String get savedTemplates => "Gespeicherte Vorlagen";
  @override
  String get renameTemplate => "Vorlage umbenennen";
  @override
  String get previewTemplate => "Vorlage ansehen";
  @override
  String get emptyWeekCannotBeSaved =>
      "Füge mindestens eine Mahlzeit hinzu, bevor du diese Woche als Vorlage speicherst.";
  @override
  String get noMealsToApply => "Es gibt keine Mahlzeiten zum Übernehmen.";
  @override
  String get applyTemplate => "Vorlage anwenden";
  @override
  String get applyTemplateDescription =>
      "Wähle, ob die Vorlage diese Woche ersetzen oder ergänzen soll.";
  @override
  String get deleteTemplate => "Vorlage löschen";
  @override
  String get templateSaved => "Vorlage gespeichert.";
  @override
  String get templateApplied => "Vorlage angewendet.";
  @override
  String get couldNotManageMealPlan =>
      "Die Essensplan-Aktion konnte nicht abgeschlossen werden.";
  @override
  String get today => "Heute";
  @override
  String get openFullWeek => "Ganze Woche öffnen";
  @override
  String get noMealsPlanned => "Keine Mahlzeiten geplant";
  @override
  String get previousWeek => "Vorherige Woche";
  @override
  String get nextWeek => "Nächste Woche";
  @override
  String get breakfast => "Frühstück";
  @override
  String get lunch => "Mittagessen";
  @override
  String get dinner => "Abendessen";
  @override
  String get snack => "Snack";
  @override
  String get addMeal => "Essen hinzufügen";
  @override
  String get editMeal => "Essen bearbeiten";
  @override
  String get recipeMeal => "Rezept";
  @override
  String get customMeal => "Eigener Eintrag";
  @override
  String get selectRecipe => "Rezept auswählen";
  @override
  String get searchRecipes => "Suchen";
  @override
  String get ownRecipes => "Eigene Rezepte";
  @override
  String get likedRecipes => "Favoriten";
  @override
  String get noLikedRecipes => "Noch keine favorisierten Rezepte";
  @override
  String get likeRecipe => "Zu Favoriten hinzufügen";
  @override
  String get unlikeRecipe => "Aus Favoriten entfernen";
  @override
  String get couldNotUpdateLike => "Der Favorit konnte nicht geändert werden.";
  @override
  String get selectCategories => "Kategorien auswählen";
  @override
  String get selectedCategories => "Kategorien";
  @override
  String get clearSelection => "Leeren";
  @override
  String get apply => "Anwenden";
  @override
  String get customMealTitle => "Bezeichnung";
  @override
  String get mealNote => "Notiz (optional)";
  @override
  String get deleteMeal => "Essen löschen";
  @override
  String get couldNotSaveMeal =>
      "Der Essensplan konnte nicht gespeichert werden.";
  @override
  String get shoppingList => "Einkaufsliste";
  @override
  String get createShoppingList => "Einkaufsliste erstellen";
  @override
  String get shoppingListName => "Listenname";
  @override
  String get noShoppingLists => "Noch keine Einkaufslisten";
  @override
  String get createFirstShoppingList => "Erste Einkaufsliste erstellen";
  @override
  String get renameShoppingList => "Einkaufsliste umbenennen";
  @override
  String get deleteShoppingList => "Einkaufsliste löschen";
  @override
  String get shoppingItems => "Einkäufe";
  @override
  String get shoppingSections => "Geschäftsbereiche";
  @override
  String get generalShoppingSection => "Allgemein";
  @override
  String get addShoppingSection => "Geschäft hinzufügen";
  @override
  String get renameShoppingSection => "Geschäft umbenennen";
  @override
  String get deleteShoppingSection => "Geschäft löschen";
  @override
  String get shoppingSectionName => "Geschäft oder Bereich";
  @override
  String get moveToShoppingSection => "In Bereich verschieben";
  @override
  String collapseShoppingSection(String name) => '"$name" einklappen';
  @override
  String expandShoppingSection(String name) => '"$name" ausklappen';
  @override
  String get dropShoppingItemHere => "Einkauf hier ablegen";
  @override
  String get couldNotSaveShoppingSection =>
      "Das Geschäft konnte nicht gespeichert werden.";
  @override
  String shoppingSectionNameAlreadyExists(String name) =>
      "Dieser Name wird bereits verwendet.";
  @override
  String get detailedShoppingList => "Detailliert";
  @override
  String get quickShoppingList => "Schnelleingabe";
  @override
  String get quickAddShoppingItem => "Einkauf hinzufügen";
  @override
  String get addShoppingItem => "Einkauf hinzufügen";
  @override
  String get editShoppingItem => "Einkauf bearbeiten";
  @override
  String get shoppingItemName => "Bezeichnung";
  @override
  String get shoppingItemNote => "Notiz (optional)";
  @override
  String get optionalQuantity => "Menge (optional)";
  @override
  String get noShoppingItems => "Diese Einkaufsliste ist leer";
  @override
  String get addToShoppingList => "Zur Einkaufsliste hinzufügen";
  @override
  String get chooseShoppingList => "Einkaufsliste auswählen";
  @override
  String get removeShoppingItem => "Einkauf entfernen";
  @override
  String removeCheckedShoppingItems(int count) =>
      "Erledigte entfernen ($count)";
  @override
  String confirmRemoveCheckedShoppingItems(int count) =>
      "Alle $count erledigten Einkäufe entfernen?";
  @override
  String confirmDeleteShoppingSection(String name) =>
      '"$name" löschen? Die Einkäufe werden nach Allgemein verschoben.';
  @override
  String get couldNotSaveShoppingList =>
      "Die Einkaufsliste konnte nicht gespeichert werden.";
  @override
  String get couldNotSaveShoppingItem =>
      "Der Einkauf konnte nicht gespeichert werden.";
  @override
  String get supermarketCategory => "Supermarktkategorie";
  @override
  String get create => "Erstellen";
  @override
  String get scanner => "Scanner";
  @override
  String get sync => "Synchronisieren";
  @override
  String get database => "Datenbank";
  @override
  String get cancelSync => "Synchronisierung abbrechen";
  @override
  String get startSync => "Synchronisierung starten";
  @override
  String get syncProgress => "Synchronisierungsfortschritt";
  @override
  String get lastSyncError => "Letzter Synchronisierungsfehler";
  @override
  String get neverSynced => "Noch nie synchronisiert";
  @override
  String get pendingSync => "Synchronisierung ausstehend";
  @override
  String get fullSync => "Vollständig synchronisiert";
  @override
  String get runningSync => "Synchronisierung läuft";
  @override
  String get cancelledSync => "Synchronisierung abgebrochen";
  @override
  String get lightDarkMode => "Heller Modus / Dunkler Modus";
  @override
  String get deviceId => "Geräte-ID";
  @override
  String get version => "Version";
  @override
  String get registrationPage => "Registrierung";
  @override
  String get accountName => "Kontoname";
  @override
  String get accountNotAvailable => "Dieses Konto ist nicht verfügbar.";
  @override
  String get editAccount => "Konto bearbeiten";
  @override
  String get bio => "Über mich";
  @override
  String get bioHint => "Erzähle anderen etwas über dich";
  @override
  String get noBioYet => "Noch keine Kontobeschreibung.";
  @override
  String get memberSince => "Mitglied seit";
  @override
  String get followers => "Follower";
  @override
  String get following => "Gefolgt";
  @override
  String get follow => "Folgen";
  @override
  String get chooseAccountImage => "Foto auswählen";
  @override
  String get couldNotUpdateAccount =>
      "Das Konto konnte nicht aktualisiert werden";
  @override
  String get email => "E-Mail";
  @override
  String get password => "Passwort";
  @override
  String get confirmPassword => "Passwort bestätigen";
  @override
  String get showPassword => "Passwort anzeigen";
  @override
  String get hidePassword => "Passwort ausblenden";
  @override
  String get passwordTooShort =>
      "Das Passwort muss mindestens 8 Zeichen enthalten.";
  @override
  String get passwordsDoNotMatch => "Die Passwörter stimmen nicht überein.";
  @override
  String get hostCode => "Host-Code";
  @override
  String get createAccount => "Konto erstellen";
  @override
  String get alreadyHaveAccount => "Bereits registriert? Anmelden";
  @override
  String get fillAllFields => "Bitte fülle alle Felder aus.";
  @override
  String get invalidHostCode => "Ungültiger Host-Code.";
  @override
  String get emailAlreadyExists => "Diese E-Mail-Adresse existiert bereits.";
  @override
  String get couldNotIdentifyDevice =>
      "Dieses Gerät konnte nicht erkannt werden.";
  @override
  String get accountNameAlreadyExists => "Dieser Kontoname existiert bereits.";
  @override
  String get registrationFailed =>
      "Die Registrierung konnte nicht abgeschlossen werden.";
  @override
  String get enterEmailAndPassword =>
      "Bitte gib E-Mail-Adresse und Passwort ein.";
  @override
  String get invalidEmailOrPassword =>
      "E-Mail-Adresse oder Passwort ist falsch.";
  @override
  String get accountNotLinked =>
      "Diese Anmeldung ist noch mit keinem App-Konto verknüpft.";
  @override
  String get verifyEmailBeforeLogin =>
      "Bestätige das Konto über deine E-Mail und melde dich danach an.";
  @override
  String get resendConfirmationEmail => "Bestätigungs-E-Mail erneut senden";
  @override
  String get confirmationEmailSent =>
      "Eine neue Bestätigungs-E-Mail wurde gesendet. Prüfe deinen Posteingang.";
  @override
  String get emailAlreadyConfirmed =>
      "Diese E-Mail-Adresse ist bereits bestätigt. Du kannst dich anmelden.";
  @override
  String get enterValidEmail => "Bitte gib eine gültige E-Mail-Adresse ein.";
  @override
  String get confirmationEmailRateLimited =>
      "Bitte warte, bevor du eine weitere Bestätigungs-E-Mail anforderst.";
  @override
  String get confirmationEmailCouldNotBeSent =>
      "Die Bestätigungs-E-Mail konnte nicht gesendet werden.";
  @override
  String get noMainProfile => "Kein Hauptprofil gefunden.";
  @override
  String get couldNotLogIn => "Die Anmeldung ist fehlgeschlagen.";
  @override
  String get codeScanner => "Code-Scanner";
  @override
  String get recipeAssets => "Rezeptanhänge";
  @override
  String get noHistorySelected => "Kein Verlaufseintrag ausgewählt!";
  @override
  String get emptyData => "Keine Daten verfügbar.";
  @override
  String get noCategoriesAvailable => "Keine Kategorien verfügbar";
  @override
  String get viewerCannotEdit =>
      "Betrachterprofile können keine Änderungen vornehmen.";
  @override
  String get manageAccess => "Zugriff verwalten";
  @override
  String get addPerson => "Person hinzufügen";
  @override
  String get sharedWith => "Geteilt mit";
  @override
  String get owner => "Eigentümer";
  @override
  String get noSharedMembers => "Noch mit niemandem geteilt.";
  @override
  String get removeAccess => "Zugriff entfernen";
  @override
  String get createMealPlan => "Essensplan erstellen";
  @override
  String get mealPlanName => "Name des Essensplans";
  @override
  String get searchAccounts => "Konten suchen";
  @override
  String get searchFriends => "Freunde suchen";
  @override
  String get suggestions => "Vorschläge";
  @override
  String get findPeople => "Personen finden";
  @override
  String get chat => "Chat";
  @override
  String get conversations => "Unterhaltungen";
  @override
  String get newConversation => "Neue Unterhaltung";
  @override
  String get noConversations => "Noch keine Unterhaltungen.";
  @override
  String get noFriendsToChat =>
      "Füge zuerst einen Freund hinzu, um eine Unterhaltung zu beginnen.";
  @override
  String get startChat => "Chat starten";
  @override
  String get couldNotLoadMessages =>
      "Nachrichten konnten nicht geladen werden.";
  @override
  String get tryAgain => "Erneut versuchen";
  @override
  String get messageHint => "Nachricht";
  @override
  String get sendMessage => "Nachricht senden";
  @override
  String get addAttachment => "Anhang hinzufügen";
  @override
  String get removeAttachment => "Anhang entfernen";
  @override
  String get shareRecipe => "Rezept teilen";
  @override
  String get sharedRecipe => "Geteiltes Rezept";
  @override
  String get recipeUnavailable => "Rezept nicht mehr verfügbar";
  @override
  String get recipeDetailsNotReady =>
      "Die Rezeptdetails werden noch geladen. Bitte versuche es erneut.";
  @override
  String get shareShoppingList => "Einkaufsliste teilen";
  @override
  String get sharedShoppingList => "Geteilte Einkaufsliste";
  @override
  String get shoppingListUnavailable => "Einkaufsliste nicht mehr verfügbar";
  @override
  String get noShoppingListsAvailableToShare =>
      "Mit dieser Person ist derzeit keine Einkaufsliste geteilt.";
  @override
  String get jumpToLatest => "Zur neuesten Nachricht";
  @override
  String get replyingTo => "Antwort auf";
  @override
  String get removeReply => "Antwort abbrechen";
  @override
  String get originalMessageUnavailable =>
      "Ursprüngliche Nachricht nicht verfügbar";
  @override
  String get reactToMessage => "Auf Nachricht reagieren";
  @override
  String get accountFound => "Konto gefunden";
  @override
  String get accountNotFound => "Kein passendes Konto gefunden";
  @override
  String get sendInvitation => "Einladung senden";
  @override
  String get invitationPending => "Einladung ausstehend";
  @override
  String get invitations => "Einladungen";
  @override
  String get noPendingInvitations => "Keine ausstehenden Einladungen.";
  @override
  String get invitedBy => "Eingeladen von";
  @override
  String get acceptInvitation => "Annehmen";
  @override
  String get declineInvitation => "Ablehnen";
  @override
  String get friends => "Freunde";
  @override
  String get friendRequests => "Freundschaftsanfragen";
  @override
  String get addFriend => "Als Freund hinzufügen";
  @override
  String get friendRequestSent => "Anfrage gesendet";
  @override
  String get removeFriend => "Freund entfernen";
  @override
  String get confirmLogout => "Möchtest du dich wirklich abmelden?";
  @override
  String get noFriends => "Noch keine Freunde.";
  @override
  String get onlyFriendsCanBeInvited =>
      "Nur bestätigte Freunde können eingeladen werden.";
  @override
  String get invalidScannedCode =>
      "Der gescannte Code ist unvollständig oder ungültig.";
  @override
  String get couldNotCreateRecipe => "Das Rezept konnte nicht erstellt werden";
  @override
  String get couldNotUpdateRecipe =>
      "Das Rezept konnte nicht aktualisiert werden";
  @override
  String get compareRecipeChanges => "Rezeptänderungen vergleichen";
  @override
  String get recipeComparisonMessage =>
      "Das Rezept wurde geändert, nachdem du den Editor geöffnet hast. Vergleiche beide Versionen, bevor du entscheidest, welche du behalten möchtest.";
  @override
  String get yourVersion => "Deine Version";
  @override
  String get latestVersion => "Aktuelle Datenbankversion";
  @override
  String get useLatestVersion => "Aktuelle Version verwenden";
  @override
  String get changed => "Geändert";
  @override
  String get couldNotCompareRecipe =>
      "Die Datenbankversion konnte nicht geladen werden. Deine Änderungen sind noch vorhanden.";
  @override
  String get recipeDeletedTitle => "Rezept wurde gelöscht";
  @override
  String get recipeDeletedRemotely =>
      "Dieses Rezept wurde auf einem anderen Gerät gelöscht. Du kannst deine Änderungen geöffnet lassen oder deine Version als neues Rezept speichern.";
  @override
  String get saveAsCopy => "Als Kopie speichern";
  @override
  String get recipeSavedAsCopy =>
      "Deine Version wurde als neues Rezept gespeichert.";
  @override
  String get couldNotLoadLatestRecipe =>
      "Die aktuelle Version konnte nicht geladen werden. Deine Änderungen sind noch vorhanden.";

  @override
  String recipeCopyTitle(String title) => "$title (Kopie)";

  @override
  String confirmRemoveFromRecipe(String name) =>
      'Möchtest du "$name" wirklich aus diesem Rezept löschen?';

  @override
  String confirmDeleteProfile(String name) =>
      'Profil "$name" löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String confirmDeleteShoppingList(String name) =>
      '"$name" und alle Einträge löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String confirmDeleteMealPlan(String name) =>
      '"$name" und alle geplanten Mahlzeiten löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String confirmDeleteTemplate(String name) =>
      'Vorlage "$name" löschen? Dies kann nicht rückgängig gemacht werden.';

  @override
  String confirmRemoveShoppingItem(String name) =>
      '"$name" aus dieser Einkaufsliste entfernen?';

  @override
  String confirmDeleteMeal(String title) =>
      '"$title" aus dem Essensplan löschen?';

  @override
  String confirmRemoveFriend(String accountName) =>
      'Möchtest du "$accountName" wirklich als Freund entfernen? Der gegenseitige Zugriff auf geteilte Essenspläne und Einkaufslisten wird ebenfalls entfernt.';

  @override
  String confirmRemoveAccess(String accountName, String resourceName) =>
      'Möchtest du "$accountName" wirklich aus "$resourceName" entfernen? Der Zugriff darauf geht verloren.';

  @override
  String addedToShoppingList(String name) => 'Zu "$name" hinzugefügt.';

  @override
  String scaledAmount(String amount) => "Menge für die Einkaufsliste: $amount";

  @override
  String mealCount(int count) =>
      count == 1 ? "1 Mahlzeit" : "$count Mahlzeiten";

  @override
  String stepCount(int count) => count == 1 ? "1 Schritt" : "$count Schritte";

  @override
  String roleLabel(String roleName) {
    switch (roleName) {
      case 'viewer':
        return 'Betrachter';
      case 'editor':
        return 'Bearbeiter';
      case 'admin':
        return 'Administrator';
      default:
        return roleName;
    }
  }

  @override
  String syncTableLabel(String tableName) {
    const labels = {
      'Roles': 'Rollen',
      'Accounts': 'Konten',
      'Account Follows': 'Gefolgte Konten',
      'Friends': 'Freunde',
      'Chats': 'Chats',
      'Messages': 'Nachrichten',
      'Reactions': 'Reaktionen',
      'Recipe Likes': 'Rezept-Likes',
      'Shopping lists': 'Einkaufslisten',
      'Shopping list members': 'Geteilte Einkaufslisten',
      'Shopping list items': 'Einkäufe',
      'Shopping categories': 'Einkaufskategorien',
      'Meal plans': 'Essenspläne',
      'Meal plan members': 'Geteilte Essenspläne',
      'Meal plan entries': 'Essensplaneinträge',
      'Meal plan templates': 'Essensplan-Vorlagen',
      'Meal plan template entries': 'Einträge der Essensplan-Vorlagen',
      'Units': 'Einheiten',
      'Recipes': 'Rezepte',
      'Recipe Steps': 'Rezeptschritte',
      'Ingredients': 'Zutaten',
      'Recipe Ingredients': 'Rezeptzutaten',
      'Recipe Step Ingredients': 'Zutaten pro Schritt',
      'Categories': 'Kategorien',
      'History': 'Verlauf',
      'Recipe Categories': 'Rezeptkategorien',
      'Comments': 'Kommentare',
      'Settings': 'Einstellungen',
    };
    return labels[tableName] ?? tableName;
  }

  @override
  String syncMutationLabel(String mutationType) {
    const labels = {
      'shopping_list_upsert': 'Einkaufsliste',
      'shopping_list_item_upsert': 'Einkaufslisteneintrag',
      'shopping_list_member_upsert': 'Freigabe der Einkaufsliste',
      'shopping_list_invitation_response': 'Einkaufslisteneinladung',
      'meal_plan_upsert': 'Essensplan',
      'meal_plan_entry_upsert': 'Essensplaneintrag',
      'meal_plan_member_upsert': 'Freigabe des Essensplans',
      'meal_plan_invitation_response': 'Essensplaneinladung',
      'meal_plan_template_upsert': 'Essensplanvorlage',
      'meal_plan_template_entry_upsert': 'Eintrag der Essensplanvorlage',
      'recipe_create': 'Neues Rezept',
      'recipe_update': 'Rezeptänderungen',
      'ingredient_category_update': 'Zutatenkategorie',
      'account_friend_request': 'Freundschaftsanfrage',
      'account_friend_response': 'Antwort auf die Freundschaftsanfrage',
      'account_friend_remove': 'Entfernen eines Freundes',
      'chat_message_send': 'Chatnachricht',
      'chat_messages_read': 'Gelesen-Status der Nachrichten',
      'chat_reaction_set': 'Nachrichtenreaktion',
    };
    return labels[mutationType] ?? mutationType;
  }

  @override
  String syncUploadFailed(String change) =>
      '$change konnte nicht hochgeladen werden.';

  @override
  String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours == 0) return '$remainingMinutes Min.';
    if (remainingMinutes == 0) return '$hours Std.';
    return '$hours Std. $remainingMinutes Min.';
  }

  @override
  String unitLabel(String unitCode) {
    const labels = {
      'tsp': 'TL',
      'tbsp': 'EL',
      'cup': 'Tasse',
      'piece': 'Stück',
      'pinch': 'Prise',
      'drop': 'Tropfen',
      'clove': 'Zehe',
      'slice': 'Scheibe',
      'handful': 'Handvoll',
      'bunch': 'Bund',
      'sprig': 'Zweig',
      'can': 'Dose',
      'package': 'Packung',
      'bottle': 'Flasche',
      'oz': 'Unze',
      'lb': 'Pfund',
      'fl_oz': 'Flüssigunze',
    };
    return labels[unitCode] ?? unitCode;
  }
}
