import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const _databaseFolder = 'craftingrecipes';
const _databaseFileName = 'craftingrecipes.db';

/// Location of the SQLite file inside the app's documents directory.
Future<File> get databaseFile async {
  final documents = await getApplicationDocumentsDirectory();
  return File(p.join(documents.path, _databaseFolder, _databaseFileName));
}

/// Opens the database on a background isolate so queries do not block the UI.
DatabaseConnection connect() => DatabaseConnection.delayed(
      databaseFile.then(NativeDatabase.createBackgroundConnection),
    );

/// In debug builds, checks that the opened schema matches the generated code.
Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  if (!kDebugMode) return;
  await VerifySelf(database).validateDatabaseSchema();
}
