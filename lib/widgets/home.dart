import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:recipes/notifiers/recipes_notifier.dart';
import 'package:recipes/providers/providers.dart';
import 'package:recipes/utils.dart';
import 'package:recipes/widgets/edit_recipe.dart';

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final recipesState = useProvider(recipesStateProvider.state);
    if (recipesState is RecipesError) {
      return Center(
        child: Text('Something went wrong'),
      );
    } else if (recipesState is RecipesLoaded) {
      return ListView.builder(
        itemCount: recipesState.recipes.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            openRecipe(context, recipesState.recipes[index].id);
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipesState.recipes[index].title,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(recipesState.recipes[index].description),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
