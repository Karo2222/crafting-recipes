import 'dart:convert';
import 'dart:io';

import 'package:craftingrecipes/helpers/constants.dart';
import 'package:craftingrecipes/helpers/localstorage/app_util.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RecipeImage extends StatefulWidget {
  const RecipeImage({
    super.key,
    required this.recipeId,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.folderName,
  });

  final int recipeId;
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  /// Local cache folder; defaults to the recipe images folder.
  final String? folderName;

  @override
  State<RecipeImage> createState() => _RecipeImageState();
}

class _RecipeImageState extends State<RecipeImage> {
  Future<String>? _localPathFuture;
  String? _resolvedLocalPath;

  bool get _hasImage =>
      widget.imageUrl != null && widget.imageUrl!.trim().isNotEmpty;

  String get _url => widget.imageUrl!.trim();

  @override
  void initState() {
    super.initState();
    _prepareLocalPath();
  }

  @override
  void didUpdateWidget(covariant RecipeImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final sourceChanged = oldWidget.recipeId != widget.recipeId ||
        oldWidget.imageUrl?.trim() != widget.imageUrl?.trim();
    if (sourceChanged || _resolvedLocalPath == '') {
      _prepareLocalPath();
    }
  }

  void _prepareLocalPath() {
    _resolvedLocalPath = null;
    if (!_hasImage || kIsWeb || _url.startsWith('data:image/')) {
      _localPathFuture = null;
      return;
    }
    _localPathFuture = AppUtil.filePath(
      widget.recipeId,
      _url,
      widget.folderName ?? Const.recipeImagesFolderName.key,
    ).then((path) {
      _resolvedLocalPath = path;
      return path;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasImage) {
      return _DefaultRecipeImage(width: widget.width, height: widget.height);
    }

    final url = _url;
    if (url.startsWith('data:image/')) {
      return Image.memory(
        base64Decode(url.substring(url.indexOf(',') + 1)),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => _DefaultRecipeImage(
          width: widget.width,
          height: widget.height,
        ),
      );
    }
    if (kIsWeb) {
      return Image.network(
        url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) =>
            _DefaultRecipeImage(width: widget.width, height: widget.height),
      );
    }

    return FutureBuilder<String>(
      future: _localPathFuture,
      builder: (_, snapshot) {
        final path = snapshot.data;
        if (path != null && path.isNotEmpty) {
          return Image.file(
            File(path),
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => _DefaultRecipeImage(
              width: widget.width,
              height: widget.height,
            ),
          );
        }

        return _DefaultRecipeImage(
          width: widget.width,
          height: widget.height,
        );
      },
    );
  }
}

class _DefaultRecipeImage extends StatelessWidget {
  const _DefaultRecipeImage({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Text(
        Languages.of(context)!.recipe,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
