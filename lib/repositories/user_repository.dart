import 'dart:convert';

import 'package:recipes/models/user.dart';
import 'package:http/http.dart' as http;

abstract class UserRepository {
  Future<User> login(String username, String password);
  Future<User> getUser(String token);
  Future<bool> logout(String token);
}

class HerokuUserRepository extends UserRepository {
  String _baseUrl = 'mochanos-recipes.herokuapp.com';

  HerokuUserRepository();

  Map<String, String> get headers => ({
        'content-type': 'application/json',
      });

  Future<User> login(String username, String password) async {
    http.Response response = await http.post(
      Uri.https(_baseUrl, '/user/login'),
      headers: headers,
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200)
      return User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    else
      return null;
  }

  Future<bool> logout(String token) async {
    http.Response response = await http.get(
      Uri.https(_baseUrl, '/user/signout'),
      headers: headers..putIfAbsent('x-user-token', () => token),
    );
    return (response.statusCode == 204);
  }

  Future<User> getUser(String token) async {
    http.Response response = await http.get(
      Uri.https(_baseUrl, '/user/me'),
      headers: headers..putIfAbsent('x-user-token', () => token),
    );
    if (response.statusCode == 200)
      return User.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    else
      return null;
  }
}
