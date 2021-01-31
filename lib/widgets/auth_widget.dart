import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipes/notifiers/auth_notifier.dart';
import 'package:recipes/providers/providers.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key key,
    @required this.authorizedBuilder,
    @required this.unauthorizedBuilder,
  }) : super(key: key);
  final WidgetBuilder unauthorizedBuilder;
  final WidgetBuilder authorizedBuilder;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authState = watch(authProvider.state);
    if (authState is AuthInitial) {
      return unauthorizedBuilder(context);
    } else if (authState is AuthLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (authState is AuthLoaded) {
      return authorizedBuilder(context);
    } else {
      if (authState is AuthError) {
        print(authState.message);
        return Scaffold(
          body: Center(
            child: Text(authState.message),
          ),
        );
      }
      return Scaffold(
        body: Center(
          child: Text('Something went wrong'),
        ),
      );
    }
  }
}
