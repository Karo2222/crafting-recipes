import 'package:craftingrecipes/languages/languages.dart';
import 'package:flutter/material.dart';

class RecipeSearchField extends StatelessWidget {
  const RecipeSearchField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) => TextField(
          controller: controller,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            hintText: l.search,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: controller.text.trim().isEmpty
                ? null
                : IconButton(
                    tooltip: l.close,
                    onPressed: controller.clear,
                    icon: const Icon(Icons.close),
                  ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
