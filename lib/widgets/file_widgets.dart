import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/navigation.dart';
import 'package:craftingrecipes/views/fullscreen_image_viewer.dart';
import 'package:craftingrecipes/widgets/recipe_image.dart';

/// Image of a recipe step; tapping it opens a zoomable full-screen view.
class StepImage extends StatelessWidget {
  const StepImage({
    super.key,
    required this.stepId,
    required this.url,
    required this.folderName,
  });

  final int stepId;
  final String url;
  final String folderName;

  String get _heroTag => 'step-image-$folderName-$stepId';

  void _openFullScreen(BuildContext context) {
    Navigator.of(context).push(
      appPageRoute(
        builder: (_) => FullScreenImageViewer(
          id: stepId,
          url: url,
          folderName: folderName,
          tagName: _heroTag,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.75,
        child: GestureDetector(
          onTap: () => _openFullScreen(context),
          child: Hero(
            tag: _heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: RecipeImage(
                recipeId: stepId,
                imageUrl: url,
                folderName: folderName,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
