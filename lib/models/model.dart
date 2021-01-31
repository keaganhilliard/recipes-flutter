class Model {
  Model();

  int _id;
  int get id => _id;
  set id(int id) => this._id = id;

  String _description;
  String get description => _description;
  set description(String description) => this._description = description;

  DateTime _createdAt;
  DateTime get createdAt => _createdAt;
  set createdAt(DateTime createdAt) => this._createdAt = createdAt;

  int _createdBy;
  int get createdBy => _createdBy;
  set createdBy(int createdBy) => this._createdBy = createdBy;

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    createdAt = DateTime.parse(json['created_at']);
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['description'] = description;
    data['created_at'] = createdAt?.toIso8601String();
    data['created_by'] = createdBy;
    return data;
  }
}
