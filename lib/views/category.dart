import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:craftingrecipes/objects/singleton.dart';
import 'package:flutter/material.dart';

Future<Set<int>?> showCategoryFilterDialog({
  required BuildContext context,
  required Set<int> selectedCategoryIds,
}) {
  return showDialog<Set<int>>(
    context: context,
    builder: (context) => _CategoryFilterDialog(
      selectedCategoryIds: selectedCategoryIds,
    ),
  );
}

class _CategoryFilterDialog extends StatefulWidget {
  const _CategoryFilterDialog({required this.selectedCategoryIds});

  final Set<int> selectedCategoryIds;

  @override
  State<_CategoryFilterDialog> createState() => _CategoryFilterDialogState();
}

class _CategoryFilterDialogState extends State<_CategoryFilterDialog> {
  final ScrollController _scrollController = ScrollController();
  late final Set<int> _selectedCategoryIds;

  @override
  void initState() {
    super.initState();
    _selectedCategoryIds = {...widget.selectedCategoryIds};
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 16, 8, 8),
      title: Row(
        children: [
          Expanded(child: Text(l.selectCategories)),
          IconButton(
            tooltip: l.close,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      content: SizedBox(
        width: 420,
        height: MediaQuery.sizeOf(context).height * 0.55,
        child: StreamBuilder<List<Category>>(
          stream: Singleton().getDatabase().allCategoryEntries,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(l.somethingWentWrong));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.isEmpty) {
              return Center(child: Text(l.noCategoriesAvailable));
            }

            return Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final category = snapshot.data![index];
                  return CheckboxListTile(
                    value: _selectedCategoryIds.contains(category.id),
                    title: Text(category.name),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedCategoryIds.add(category.id);
                        } else {
                          _selectedCategoryIds.remove(category.id);
                        }
                      });
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _selectedCategoryIds.isEmpty
              ? null
              : () => setState(_selectedCategoryIds.clear),
          child: Text(l.clearSelection),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_selectedCategoryIds),
          child: Text(l.apply),
        ),
      ],
    );
  }
}

class CategoryFilterButton extends StatelessWidget {
  const CategoryFilterButton({
    super.key,
    required this.selectedCategoryIds,
    required this.onChanged,
  });

  final Set<int> selectedCategoryIds;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = Languages.of(context)!;
    final selectedCount = selectedCategoryIds.length;
    return OutlinedButton.icon(
      onPressed: () async {
        final result = await showCategoryFilterDialog(
          context: context,
          selectedCategoryIds: selectedCategoryIds,
        );
        if (result != null) onChanged(result);
      },
      icon: const Icon(Icons.filter_list),
      label: Text(
        selectedCount == 0
            ? l.categorieButtonText
            : '${l.selectedCategories} ($selectedCount)',
      ),
    );
  }
}
