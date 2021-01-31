import 'package:flutter/foundation.dart';
import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/repositories/recipe_repository.dart';
import 'package:riverpod/all.dart';

abstract class RecipeState {
  const RecipeState();
}

class RecipeInitial extends RecipeState {
  const RecipeInitial();
}

class RecipeLoading extends RecipeState {
  const RecipeLoading();
}

class RecipeLoaded extends RecipeState {
  final Recipe _recipe;
  Recipe get recipe => _recipe;

  final List<Ingredient> _ingredients;
  List<Ingredient> get ingredients => _ingredients;

  final List<Instruction> _instructions;
  List<Instruction> get instructions => _instructions;

  const RecipeLoaded(this._recipe, this._ingredients, this._instructions);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecipeLoaded &&
        _recipe.id == other.recipe.id &&
        listEquals(_ingredients, other.ingredients) &&
        listEquals(_instructions, other.instructions);
  }

  @override
  int get hashCode => _recipe.hashCode;
}

class RecipeError extends RecipeState {
  final String message;
  const RecipeError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RecipeError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class RecipeNotifier extends StateNotifier<RecipeState> {
  final RecipeRepository _recipeRepository;

  RecipeNotifier(this._recipeRepository) : super(RecipeInitial());

  addNewIngredient() {
    if (state is RecipeLoaded) {
      var loadedState = (state as RecipeLoaded);
      state = RecipeLoaded(
        loadedState.recipe,
        [
          ...loadedState.ingredients,
          Ingredient(),
        ],
        loadedState.instructions,
      );
    }
  }

  removeIngredient(Ingredient i) {
    if (state is RecipeLoaded) {
      var loadedState = state as RecipeLoaded;
      state = RecipeLoaded(
        loadedState.recipe,
        loadedState.ingredients.where((ingredient) => ingredient != i).toList(),
        loadedState.instructions,
      );
    }
  }

  removeInstruction(Instruction i) {
    if (state is RecipeLoaded) {
      var loadedState = state as RecipeLoaded;
      state = RecipeLoaded(
        loadedState.recipe,
        loadedState.ingredients,
        loadedState.instructions
            .where((instruction) => instruction != i)
            .toList(),
      );
    }
  }

  addNewInstruction() {
    if (state is RecipeLoaded) {
      var loadedState = (state as RecipeLoaded);
      state = RecipeLoaded(
        loadedState.recipe,
        loadedState.ingredients,
        [
          ...loadedState.instructions,
          Instruction(number: loadedState.instructions.length + 1),
        ],
      );
    }
  }

  Future<RecipeLoaded> _getLoadedRecipe(int id) async {
    final recipe = await _recipeRepository.fetchRecipeById(id);
    final ingredients = await _recipeRepository.fetchIngredientsForRecipe(id);
    final instructions = await _recipeRepository.fetchInstructionsForRecipe(id);
    return RecipeLoaded(
        recipe, ingredients ?? const [], instructions ?? const []);
  }

  Future refreshRecipe(int id) async {
    state = await _getLoadedRecipe(id);
  }

  Future getRecipe(int id) async {
    if (id == null)
      state = RecipeLoaded(Recipe(), const [], const []);
    else
      try {
        state = RecipeLoading();
        state = await _getLoadedRecipe(id);
      } catch (e) {
        state = RecipeError(e.toString());
      }
  }
}
