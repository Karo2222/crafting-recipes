import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:craftingrecipes/languages/languages.dart';

/// Full-screen camera view that reports every detected QR/barcode.
class CodeScanner extends StatefulWidget {
  const CodeScanner({super.key, required this.onDetect});

  final void Function(BarcodeCapture capture) onDetect;

  @override
  State<CodeScanner> createState() => _CodeScannerState();
}

class _CodeScannerState extends State<CodeScanner> {
  final _controller =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Languages.of(context)!.codeScanner)),
      body: MobileScanner(controller: _controller, onDetect: widget.onDetect),
    );
  }
}
