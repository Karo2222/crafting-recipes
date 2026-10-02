import 'package:flutter/foundation.dart';

/// Holds the most recent value read by the QR/barcode scanner.
class ScanModel extends ChangeNotifier {
  String _value = '';

  String get text => _value;

  void updateText(String value) {
    if (value == _value) return;
    _value = value;
    notifyListeners();
  }
}
