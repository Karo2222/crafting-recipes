import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/constants.dart';
import 'package:craftingrecipes/helpers/device_info.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:craftingrecipes/widgets/file_widgets.dart';
import 'package:craftingrecipes/languages/languages.dart';

class RecipeStepView extends StatefulWidget {
  const RecipeStepView(
      {super.key,
      required this.recipeTitle,
      required this.recipeStep,
      this.ingredientScale = 1,
      this.embedded = false});

  final String recipeTitle;
  final RecipeStep recipeStep;
  final double ingredientScale;
  final bool embedded;

  @override
  State<RecipeStepView> createState() => _RecipeStepViewState();
}

class _RecipeStepViewState extends State<RecipeStepView> {
  final String tagName = "stepTag";
  late Stream<List<IngredientsOfRecipeStepResult>> _ingredients;

  @override
  void initState() {
    super.initState();
    _ingredients = Singleton()
        .getDatabase()
        .getIngredientsByRecipeStepId(widget.recipeStep.id);
  }

  @override
  void didUpdateWidget(covariant RecipeStepView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.recipeStep.id != widget.recipeStep.id) {
      _ingredients = Singleton()
          .getDatabase()
          .getIngredientsByRecipeStepId(widget.recipeStep.id);
    }
  }

  Widget getFileWidget(RecipeStep step) {
    final image = step.image?.trim() ?? '';
    if (image.isEmpty) return const SizedBox.shrink();
    return StepImage(
      stepId: step.id,
      url: image,
      folderName: Const.recipeStepsImagesFolderName.key,
    );
  }

  Widget _buildTabletLayout() {
    return SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Flexible(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildStepIngredients(),
                  HtmlWidget(
                    widget.recipeStep.description,
                  ),
                ], // scrollable Column
              ),
            ),
          ),
          widget.recipeStep.image != null && widget.recipeStep.image!.isNotEmpty
              ? Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Flexible(
                        child: getFileWidget(widget.recipeStep),
                      )
                    ], //non scrollable Column
                  ),
                )
              : Container(),
        ]));
  }

  Widget _buildMobileLayout() {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildStepIngredients(),
        HtmlWidget(widget.recipeStep.description),
        getFileWidget(widget.recipeStep),
      ],
    );
    return widget.embedded ? content : SingleChildScrollView(child: content);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) return _buildMobileLayout();
    return OrientationBuilder(
      builder: (context, orientation) {
        if (DeviceInfo.inTabletLayout(context)) {
          return _buildTabletLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget buildStepIngredients() {
    return StreamBuilder(
        stream: _ingredients,
        builder: (BuildContext context,
            AsyncSnapshot<List<IngredientsOfRecipeStepResult>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(
                  '${Languages.of(context)!.somethingWentWrong} ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: snapshot.data!.map((ingredient) {
                    final amount = ingredient.amount;
                    final note = ingredient.quantityNote?.trim();
                    final quantity = amount != null && ingredient.unit != null
                        ? '${_formatAmount(amount * widget.ingredientScale)} ${Languages.of(context)!.unitLabel(ingredient.unit!)}'
                        : (note == null || note.isEmpty
                            ? Languages.of(context)!.quantityNotSpecified
                            : note);
                    return Chip(
                      label: Text('$quantity ${ingredient.name}'),
                    );
                  }).toList(),
                ),
              );
            }
            return Container();
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  String _formatAmount(double amount) {
    final rounded = (amount * 1000).round() / 1000;
    return rounded == rounded.roundToDouble()
        ? rounded.toInt().toString()
        : rounded.toString();
  }
}
