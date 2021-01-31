import 'package:recipes/notifiers/recipe_notifier.dart';
import 'package:recipes/notifiers/auth_notifier.dart';
import 'package:recipes/notifiers/recipes_notifier.dart';
import 'package:recipes/repositories/user_repository.dart';
import 'package:recipes/repositories/recipe_repository.dart';
import 'package:recipes/services/shared_preferences_service.dart';
import 'package:riverpod/all.dart';

final userRepositoryProvider =
    Provider<UserRepository>((ref) => HerokuUserRepository());

final authProvider = StateNotifierProvider<AuthNotifier>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return AuthNotifier(userRepo, sharedPreferencesService);
});

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final authState = ref.watch(authProvider.state);
  if (authState is AuthLoaded) {
    return HerokuRecipeRepository(authState.user.token);
  } else
    return null;
});

final recipesStateProvider = StateNotifierProvider<RecipesNotifier>((ref) {
  final recipeRepo = ref.watch(recipeRepositoryProvider);

  return RecipesNotifier(recipeRepo);
});

final recipeStateProvider = StateNotifierProvider<RecipeNotifier>((ref) {
  final recipeRepo = ref.watch(recipeRepositoryProvider);
  return RecipeNotifier(recipeRepo);
});
