import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/models/user.dart';
import 'package:recipes/repositories/user_repository.dart';
import 'package:recipes/services/shared_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/repositories/recipe_repository.dart';
import 'package:riverpod/all.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoaded extends AuthState {
  final User _user;
  User get user => _user;

  const AuthLoaded(this._user);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthLoaded && user.username == other.user.username;
  }

  @override
  int get hashCode => _user.hashCode;
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is AuthError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final UserRepository _userRepository;
  final SharedPreferencesService _sharedPreferencesService;

  AuthNotifier(this._userRepository, this._sharedPreferencesService)
      : super(AuthInitial()) {
    checkToken();
  }

  Future<bool> logout() async {
    try {
      state = AuthLoading();
      final token = _sharedPreferencesService.getCurrentToken();
      _sharedPreferencesService.setUserToken('');
      bool success = await _userRepository.logout(token);
      print('$success');
      state = AuthInitial();
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final user = await _userRepository.login(username, password);
      _sharedPreferencesService.setUserToken(user.token);
      print('Token!: ${user.token}');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future checkToken() async {
    try {
      state = AuthLoading();
      final token = _sharedPreferencesService.getCurrentToken();
      final user = await _userRepository.getUser(token);
      if (user != null)
        state = AuthLoaded(user);
      else {
        _sharedPreferencesService.setUserToken('');
        state = AuthInitial();
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
}
