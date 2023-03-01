
import 'package:flutter/material.dart';

  Future<void> notificationCannotConnect(BuildContext context, String name) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Opening Connection'),
          content: Text('Unable to connect to $name'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme
                    .of(context)
                    .textTheme
                    .labelLarge,
              ),
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

Future<void> notificationNoScribblersFound(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('No Scribblers Found'),
        content: const Text('The scan did not find any scribblers'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
            ),
            child: const Text('Dismiss'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> notificationScanComplete(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Scan for Scribblers is complete'),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
            ),
            child: const Text('Dismiss'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}