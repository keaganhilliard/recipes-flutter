import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const userTokenKey = 'USER_TOKEN';

  Future<void> setUserToken(String token) async {
    await sharedPreferences.setString(userTokenKey, token);
  }

  String getCurrentToken() => sharedPreferences.getString(userTokenKey) ?? '';
}
