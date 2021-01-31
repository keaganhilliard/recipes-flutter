import 'package:recipes/models/model.dart';

class Recipe extends Model {
  Recipe({
    int id,
    String title,
    String source,
    String description,
    String duration,
    String servings,
    String notes,
  }) {
    this.id = id;
    this.title = title;
    this.source = source;
    this.description = description;
    this.duration = duration;
    this.servings = servings;
    this.notes = notes;
  }

  String _title;
  String get title => _title;
  set title(String title) => this._title = title;

  String _source;
  get source => _source;
  set source(String source) => this._source = source;

  String _duration;
  get duration => _duration;
  set duration(String duration) => this._duration = duration;

  String _servings;
  get servings => _servings;
  set servings(String servings) => this._servings = servings;

  String _notes;
  get notes => _notes;
  set notes(String notes) => this._notes = notes;

  Recipe.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    title = json['title'];
    source = json['source'];
    duration = json['duration'];
    servings = json['servings'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['title'] = title;
    data['source'] = source;
    data['duration'] = duration;
    data['servings'] = servings;
    data['notes'] = notes;
    return data;
  }
}
