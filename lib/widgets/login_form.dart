import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipes/providers/providers.dart';

class LoginForm extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _username =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final _password =
        useTextEditingController.fromValue(TextEditingValue.empty);
    final auth = useProvider(authProvider);
    final _formKey = GlobalKey<FormState>();
    final _loading = useState(false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 72.0, right: 72.0, top: 100.0, bottom: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.headline2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    key: ValueKey('username-field'),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a username' : null,
                    controller: _username,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    key: ValueKey('password-field'),
                    validator: (value) =>
                        value.isEmpty ? 'Please enter a password' : null,
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _loading.value
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _loading.value = true;
                            if (!await auth.login(
                                _username.text, _password.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Username or password invalid')));
                            } else
                              auth.checkToken();
                            _loading.value = false;
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
