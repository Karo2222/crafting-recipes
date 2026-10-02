import 'package:drift/drift.dart';

// Fallback used only when neither dart:ffi nor JS interop is available.

DatabaseConnection connect() => throw UnsupportedError(
    'Local storage is not available on this platform.');

Future<void> validateDatabaseSchema(GeneratedDatabase database) =>
    throw UnsupportedError('Local storage is not available on this platform.');
