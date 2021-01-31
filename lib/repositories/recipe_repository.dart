import 'dart:convert';

import 'package:recipes/models/ingredient.dart';
import 'package:recipes/models/instruction.dart';
import 'package:recipes/models/recipe.dart';
import 'package:http/http.dart' as http;

abstract class RecipeRepository {
  Future<List<Recipe>> fetchAllRecipes();
  Future<List<Recipe>> search(String query);
  Future<Recipe> fetchRecipeById(int id);
  Future<bool> deleteRecipeById(int id);
  Future<List<Ingredient>> fetchIngredientsForRecipe(int id);
  Future<Recipe> updateRecipe(Recipe recipe);
  Future<List<Ingredient>> updateIngredients(
      int id, List<Ingredient> ingredients);
  Future<List<Instruction>> fetchInstructionsForRecipe(int id);
  Future<List<Instruction>> updateInstructions(
      int id, List<Instruction> ingredients);
  Future<bool> deleteIngredientById(int id);
  Future<bool> deleteInstructionById(int id);
}

class HerokuRecipeRepository extends RecipeRepository {
  String _token;
  String _baseUrl = 'mochanos-recipes.herokuapp.com';

  HerokuRecipeRepository(this._token);

  Map<String, String> get headers =>
      ({'x-user-token': _token, 'content-type': 'application/json'});

  Future<List<Recipe>> fetchAllRecipes() async {
    http.Response response = await http.get(
      Uri.https(_baseUrl, '/recipe'),
      headers: headers,
    );
    return jsonDecode(utf8.decode(response.bodyBytes))
        .cast<Map<String, dynamic>>()
        .map<Recipe>((json) => Recipe.fromJson(json))
        .toList();
  }

  Future<Recipe> fetchRecipeById(int id) async {
    http.Response response = await http.get(
      Uri.https(_baseUrl, '/recipe/$id'),
      headers: headers,
    );
    if (response.statusCode == 200)
      return jsonDecode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>()
          .map<Recipe>((json) => Recipe.fromJson(json))
          .toList()[0];
    else
      return Recipe();
  }

  Future<bool> deleteRecipeById(int id) async {
    http.Response response = await http.delete(
      Uri.https(_baseUrl, '/recipe/$id'),
      headers: headers,
    );
    return (response.statusCode == 204);
  }

  Future<List<Ingredient>> fetchIngredientsForRecipe(int id) async {
    http.Response response = await http.get(
      Uri.https(_baseUrl, '/recipe/$id/ingredients'),
      headers: headers,
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200)
      return jsonDecode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>()
          .map<Ingredient>((json) => Ingredient.fromJson(json))
          .toList();
    else
      return null;
  }

  Future<List<Ingredient>> updateIngredients(
      int id, List<Ingredient> ingredients) async {
    http.Response response = await http.post(
        Uri.https(_baseUrl, '/recipe/$id/ingredients'),
        headers: headers,
        body: jsonEncode(ingredients.map((i) => i.toJson()).toList()));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200)
      return jsonDecode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>()
          .map<Ingredient>((json) => Ingredient.fromJson(json))
          .toList();
    else
      return null;
  }

  Future<List<Instruction>> fetchInstructionsForRecipe(int id) async {
    http.Response response = await http.get(
      Uri.https(_baseUrl, '/recipe/$id/steps'),
      headers: headers,
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200)
      return jsonDecode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>()
          .map<Instruction>((json) => Instruction.fromJson(json))
          .toList();
    else
      return null;
  }

  Future<List<Instruction>> updateInstructions(
      int id, List<Instruction> instructions) async {
    http.Response response = await http.post(
        Uri.https(_baseUrl, '/recipe/$id/steps'),
        headers: headers,
        body: jsonEncode(instructions.map((i) => i.toJson()).toList()));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200)
      return jsonDecode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>()
          .map<Instruction>((json) => Instruction.fromJson(json))
          .toList();
    else
      return null;
  }

  Future<List<Recipe>> search(String query) async {
    http.Response response = await http.get(
      Uri.https(_baseUrl, '/recipe/search/$query'),
      headers: headers,
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200)
      return jsonDecode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>()
          .map<Recipe>((json) => Recipe.fromJson(json))
          .toList();
    else
      return null;
  }

  Future<Recipe> updateRecipe(Recipe recipe) async {
    http.Response response;
    if (recipe.id == null)
      response = await http.post(
        Uri.https(_baseUrl, '/recipe'),
        headers: headers,
        body: jsonEncode(recipe.toJson()),
      );
    else
      response = await http.put(
        Uri.https(_baseUrl, '/recipe/${recipe.id}'),
        headers: headers,
        body: jsonEncode(recipe.toJson()),
      );
    print(recipe.toJson());
    print(response.body);
    if (response.statusCode == 200)
      return jsonDecode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>()
          .map<Recipe>((json) => Recipe.fromJson(json))
          .toList()[0];
    return null;
  }

  Future<bool> deleteIngredientById(int id) async {
    http.Response response = await http.delete(
      Uri.https(_baseUrl, '/ingredient/$id'),
      headers: headers,
    );
    return (response.statusCode == 204);
  }

  Future<bool> deleteInstructionById(int id) async {
    http.Response response = await http.delete(
      Uri.https(_baseUrl, '/step/$id'),
      headers: headers,
    );
    return (response.statusCode == 204);
  }
}
