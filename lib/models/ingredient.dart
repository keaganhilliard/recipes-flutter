import 'package:recipes/models/model.dart';

class Ingredient extends Model {
  Ingredient();

  String _measurement;
  String get measurement => _measurement;
  set measurement(String measurement) => this._measurement = measurement;

  String _quantity;
  String get quantity => _quantity;
  set quantity(String quantity) => this._quantity = quantity;

  int _recipeId;
  int get recipeId => _recipeId;
  set recipeId(int recipeId) => this._recipeId = recipeId;

  Ingredient.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    measurement = json['measurement'];
    quantity = json['quantity'];
    recipeId = json['recipe_id'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['measurement'] = measurement;
    data['quantity'] = quantity;
    data['recipe_id'] = recipeId;
    return data;
  }
}
