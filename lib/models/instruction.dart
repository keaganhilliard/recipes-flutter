import 'package:recipes/models/model.dart';

class Instruction extends Model {
  Instruction({int number, int recipeId, String description}) {
    this.number = number;
    this.recipeId = recipeId;
    this.description = description;
  }

  int _number;
  int get number => _number;
  set number(int number) => this._number = number;

  int _recipeId;
  int get recipeId => _recipeId;
  set recipeId(int recipeId) => this._recipeId = recipeId;

  Instruction.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    number = json['number'];
    recipeId = json['recipe_id'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['number'] = number;
    data['recipe_id'] = recipeId;
    return data;
  }
}
