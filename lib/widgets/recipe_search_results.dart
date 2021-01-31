import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/providers/providers.dart';
import 'package:recipes/utils.dart';

class RecipeSearchResults extends HookWidget {
  final String _search;
  RecipeSearchResults(this._search);

  @override
  Widget build(BuildContext context) {
    final recipeRepository = useProvider(recipeRepositoryProvider);

    if (_search.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    return FutureBuilder<List<Recipe>>(
      future: recipeRepository.search(_search),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data.length > 0) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final item = snapshot.data[index];
              return InkWell(
                onTap: () {
                  openRecipe(context, item.id);
                },
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(item.description),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: snapshot.data.length,
          );
        } else {
          return Center(
            child: Text(
              "No Results Found.",
            ),
          );
        }
      },
    );
  }
}
