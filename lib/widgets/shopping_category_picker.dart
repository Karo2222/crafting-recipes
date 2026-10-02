import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/languages/languages.dart';
import 'package:flutter/material.dart';

String shoppingCategoryLabel(
  ShoppingCategory category,
  String languageCode,
) {
  return languageCode == 'de' ? category.nameDe : category.nameEn;
}

IconData shoppingCategoryIcon(String code) {
  return switch (code) {
    'produce' => Icons.eco_outlined,
    'bakery' => Icons.bakery_dining_outlined,
    'dairy_eggs' => Icons.egg_alt_outlined,
    'meat_fish' => Icons.set_meal_outlined,
    'pantry' => Icons.kitchen_outlined,
    'frozen' => Icons.ac_unit,
    'drinks' => Icons.local_drink_outlined,
    'household' => Icons.cleaning_services_outlined,
    _ => Icons.category_outlined,
  };
}

Future<String?> showShoppingCategoryPicker({
  required BuildContext context,
  required List<ShoppingCategory> categories,
  required String initialCode,
}) {
  final l = Languages.of(context)!;
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => SimpleDialog(
      title: Text(l.supermarketCategory),
      children: categories
          .map(
            (category) => SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(category.code),
              child: Row(
                children: [
                  Icon(shoppingCategoryIcon(category.code), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      shoppingCategoryLabel(category, l.languageCode),
                    ),
                  ),
                  if (category.code == initialCode)
                    const Icon(Icons.check, size: 20),
                ],
              ),
            ),
          )
          .toList(),
    ),
  );
}
