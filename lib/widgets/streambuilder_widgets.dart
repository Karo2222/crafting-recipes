import 'package:flutter/material.dart';
import 'package:craftingrecipes/helpers/localstorage/localstorage.dart';
import 'package:craftingrecipes/languages/languages.dart';

/// App bar title showing the title of the first recipe in [recipes].
Widget getTitleStream(Stream<List<Recipe>> recipes) {
  return StreamBuilder<List<Recipe>>(
    stream: recipes,
    builder: (context, snapshot) {
      final l = Languages.of(context)!;
      if (snapshot.hasError) {
        return Text('${l.somethingWentWrong} ${snapshot.error}');
      }
      final data = snapshot.data;
      if (data == null) {
        return snapshot.connectionState == ConnectionState.done
            ? Text(l.emptyData)
            : const SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
      }
      if (data.isEmpty) return Text(l.emptyData);
      return FittedBox(fit: BoxFit.scaleDown, child: Text(data.first.title));
    },
  );
}
