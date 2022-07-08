import 'package:flutter/material.dart';

import '../question.dart';

Future<bool> openSaveConfirmDialog(BuildContext context) async {
  final saved = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('保存しますか？'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('保存する'),
          ),
          ElevatedButton(
            child: const Text('やめる'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
  if (saved == null) {
    return false;
  }
  return saved;
}
