import 'package:flutter/material.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/providers/providers.dart';
import 'package:recipes/widgets/edit_recipe.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void openRecipe(BuildContext context, int id) {
  context.read(recipeStateProvider).getRecipe(id);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => EditRecipe(),
    ),
  );
}

bool isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 640.0;
}

Function(String) requireValue(String message) {
  return (val) => val.isEmpty ? 'This field is required' : null;
}
