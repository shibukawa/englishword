import 'package:flutter/material.dart';

import '../question.dart';

Future<bool> openDeleteDialog(BuildContext context, Question src) async {
  final saved = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('問題を消す'),
        content: Text("${src.question}を消します"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('消す'),
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
