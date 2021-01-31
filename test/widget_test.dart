import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/all.dart';

import 'package:recipes/main.dart';
import 'package:recipes/models/user.dart';
import 'package:recipes/providers/providers.dart';
import 'package:recipes/repositories/user_repository.dart';
import 'package:recipes/services/shared_preferences_service.dart';
import 'package:recipes/widgets/home.dart';
import 'package:recipes/widgets/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

const TOKEN = 'TOKEN';
const USERNAME = 'TESTER';
const PASSWORD = 'PASSWORD';

class MockUserRepo extends UserRepository {
  final user = User.fromJson({
    'username': USERNAME,
    'token': TOKEN,
    'created_at': DateTime.now().toIso8601String(),
    'created_by': 1,
    'description': '',
  });

  @override
  Future<User> login(String username, String password) async {
    final com = Completer<User>();
    com.complete((username == USERNAME && password == PASSWORD) ? user : null);
    return com.future;
  }

  @override
  Future<User> getUser(String token) async {
    final com = Completer<User>();
    com.complete(token == TOKEN ? user : null);
    return com.future;
  }

  @override
  Future<bool> logout(String token) async {
    final com = Completer<bool>();
    com.complete(token == TOKEN);
    return com.future;
  }
}

void main() {
  testWidgets('Test Valid Login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    final spService = SharedPreferencesService(pref);
    spService.setUserToken('');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(spService),
          userRepositoryProvider
              .overrideWithProvider(Provider((ref) => MockUserRepo()))
        ],
        child: RecipeApp(),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);

    var fields = find.byType(TextFormField);
    var username = fields.at(0);
    var password = fields.at(1);

    await tester.tap(username);
    await tester.enterText(username, USERNAME);
    expect(find.text(USERNAME), findsOneWidget);

    await tester.tap(password);
    await tester.enterText(password, PASSWORD);
    expect(find.text(PASSWORD), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(Home), findsOneWidget);
  });

  testWidgets('Test Invalid Login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    final spService = SharedPreferencesService(pref);
    spService.setUserToken('');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesServiceProvider.overrideWithValue(spService),
          userRepositoryProvider
              .overrideWithProvider(Provider((ref) => MockUserRepo()))
        ],
        child: RecipeApp(),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);

    var fields = find.byType(TextFormField);
    var username = fields.at(0);
    var password = fields.at(1);

    await tester.tap(username);
    await tester.enterText(username, USERNAME);
    expect(find.text(USERNAME), findsOneWidget);

    await tester.tap(password);
    await tester.enterText(password, 'bad');
    expect(find.text('bad'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(LoginForm), findsOneWidget);
  });
}
