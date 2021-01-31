import 'package:flutter/material.dart';

class AreYouSure extends StatelessWidget {
  final Function() _onConfirmed;
  AreYouSure(this._onConfirmed);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('This is irreversible, are you sure you want to delete?'),
      actions: [
        TextButton(
          onPressed: _onConfirmed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('I am sure'),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No'),
          ),
        ),
      ],
    );
  }
}
