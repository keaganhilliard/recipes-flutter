import 'package:recipes/models/model.dart';

class User extends Model {
  String _username;
  String get username => _username;
  set username(String username) => this._username = username;

  String _token;
  String get token => _token;
  set token(String token) => this._token = token;

  User.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    username = json['username'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['username'] = username;
    data['token'] = token;
    return data;
  }
}
