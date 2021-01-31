import 'package:flutter/foundation.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/repositories/recipe_repository.dart';
import 'package:riverpod/all.dart';

abstract class RecipesState {
  const RecipesState();
}

class RecipesInitial extends RecipesState {
  const RecipesInitial();
}

class RecipesLoading extends RecipesState {
  const RecipesLoading();
}

class RecipesLoaded extends RecipesState {
  final List<Recipe> _recipes;
  List<Recipe> get recipes => _recipes;

  const RecipesLoaded(this._recipes);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecipesLoaded && listEquals(_recipes, other.recipes);
  }

  @override
  int get hashCode => _recipes.hashCode;
}

class RecipesError extends RecipesState {
  final String message;
  const RecipesError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RecipesError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class RecipesNotifier extends StateNotifier<RecipesState> {
  final RecipeRepository _recipeRepository;

  RecipesNotifier(this._recipeRepository) : super(RecipesInitial()) {
    getRecipes();
  }

  Future getRecipes() async {
    try {
      state = RecipesLoading();
      final recipes = await _recipeRepository.fetchAllRecipes();
      state = RecipesLoaded(recipes);
      print((state as RecipesLoaded).recipes);
    } catch (e) {
      state = RecipesError(e.toString());
    }
  }
}
