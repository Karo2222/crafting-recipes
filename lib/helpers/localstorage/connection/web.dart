import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart' show debugPrint;

const _databaseName = 'craftingrecipes-app';

Future<QueryExecutor> _openWasmDatabase() async {
  final result = await WasmDatabase.open(
    databaseName: _databaseName,
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
  );
  if (result.missingFeatures.isNotEmpty) {
    debugPrint('Local storage runs as ${result.chosenImplementation}; '
        'missing browser features: ${result.missingFeatures}');
  }
  return result.resolvedExecutor;
}

/// Opens the database in the browser using SQLite compiled to WebAssembly.
DatabaseConnection connect() =>
    DatabaseConnection.delayed(_openWasmDatabase().then(DatabaseConnection.new));

/// Schema validation is only supported on native platforms.
Future<void> validateDatabaseSchema(GeneratedDatabase database) async {}
