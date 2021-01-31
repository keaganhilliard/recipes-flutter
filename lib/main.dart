import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/notifiers/auth_notifier.dart';
import 'package:recipes/providers/providers.dart';
import 'package:recipes/utils.dart';
import 'package:recipes/widgets/adaptive_scaffold.dart';
import 'package:recipes/widgets/auth_widget.dart';
import 'package:recipes/widgets/edit_recipe.dart';
import 'package:recipes/widgets/home.dart';
import 'package:recipes/widgets/login_form.dart';
import 'package:recipes/widgets/recipe_search_delegate.dart';
import 'package:recipes/widgets/report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipes/services/shared_preferences_service.dart';

Future<void> main() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(
          SharedPreferencesService(sharedPreferences),
        )
      ],
      child: RecipeApp(),
    ),
  );
}

final destinationIndexProvider = StateProvider((_) => 0);

final destinationProvider = StateProvider<Widget>((ref) {
  final destinationIndex = ref.watch(destinationIndexProvider);
  final authState = ref.watch(authProvider.state);

  if (authState is AuthLoaded) {
    if (destinationIndex.state == 1) {
      return Report();
    } else {
      return Home();
    }
  } else
    return Container();
});

class RecipeApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final title = useState('Recipes');
    final destinationIndex = useProvider(destinationIndexProvider);

    destinationIndex.addListener((state) {
      if (state == 1)
        title.value = 'Reports';
      else
        title.value = 'Recipes';
    });

    final destination = useProvider(destinationProvider);
    final auth = useProvider(authProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipes',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AuthWidget(
          authorizedBuilder: (context) {
            final authState = context.read(authProvider.state) as AuthLoaded;
            print(authState.user.token);

            return AdaptiveScaffold(
              title: Text(title.value),
              currentIndex: destinationIndex.state,
              trailing: TextButton(
                onPressed: () async {
                  await auth.logout();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Sign out'),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                        context: context, delegate: RecipeSearchDelegate());
                  },
                ),
              ],
              destinations: [
                Destination(icon: Icons.home, title: 'Home'),
                Destination(icon: Icons.list, title: 'Reports'),
              ],
              onNavigationIndexChange: (index) =>
                  destinationIndex.state = index,
              body: destination.state,
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  openRecipe(context, null);
                },
              ),
            );
          },
          unauthorizedBuilder: (context) => LoginForm()),
    );
  }
}
