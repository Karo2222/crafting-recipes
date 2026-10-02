// Picks the database backend for the current platform at compile time:
// native SQLite via FFI on mobile/desktop, WebAssembly SQLite in the browser.
export 'unsupported.dart'
    if (dart.library.ffi) 'native.dart'
    if (dart.library.js_interop) 'web.dart';
