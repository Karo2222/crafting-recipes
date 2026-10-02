import 'dart:convert' show base64Decode;
import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/localstorage/app_util.dart';
import 'package:craftingrecipes/languages/languages.dart';

/// Shows a single image on a black background with pinch and double-tap zoom.
///
/// The image can be an inline `data:` URL, a network URL (web) or a file that
/// was cached locally during sync (mobile and desktop).
class FullScreenImageViewer extends StatefulWidget {
  const FullScreenImageViewer({
    super.key,
    required this.id,
    required this.url,
    required this.folderName,
    required this.tagName,
  });

  final int id;
  final String url;
  final String folderName;
  final String tagName;

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  static const double _doubleTapZoom = 3;

  final _zoom = TransformationController();
  Offset _lastDoubleTap = Offset.zero;

  @override
  void dispose() {
    _zoom.dispose();
    super.dispose();
  }

  void _toggleZoom() {
    if (_zoom.value.getMaxScaleOnAxis() > 1) {
      _zoom.value = Matrix4.identity();
      return;
    }
    // Zoom in around the tapped point.
    final focus = _lastDoubleTap * (_doubleTapZoom - 1);
    _zoom.value = Matrix4.identity()
      ..translate(-focus.dx, -focus.dy)
      ..scale(_doubleTapZoom);
  }

  Widget _message(String text) => Center(
        child: Text(text, style: const TextStyle(color: Colors.white)),
      );

  Widget _image(Languages l) {
    final url = widget.url;
    if (url.startsWith('data:image/')) {
      return Image.memory(base64Decode(url.split(',').last),
          fit: BoxFit.contain);
    }
    if (kIsWeb) {
      return Image.network(
        url,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _message(l.noImageAvailable),
      );
    }
    return FutureBuilder<String>(
      future: AppUtil.filePath(widget.id, url, widget.folderName),
      builder: (_, snapshot) {
        if (snapshot.hasError) return _message(l.somethingWentWrong);
        final path = snapshot.data;
        if (path == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return path.isEmpty
            ? _message(l.noImageAvailable)
            : Image.file(File(path), fit: BoxFit.contain);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onDoubleTapDown: (details) => _lastDoubleTap = details.localPosition,
            onDoubleTap: _toggleZoom,
            child: Hero(
              tag: widget.tagName,
              child: InteractiveViewer(
                transformationController: _zoom,
                maxScale: 5,
                child: _image(l),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                tooltip: l.close,
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
