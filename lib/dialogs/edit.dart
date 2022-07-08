import 'package:flutter/material.dart';

import '../question.dart';

Future<Question> openEditDialog(BuildContext context, Question src) async {
  final question = TextEditingController(text: src.question);
  final answer = TextEditingController(text: src.answer);

  final saved = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('問題変更'),
        content: Center(
          child:Column(
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: '問題'),
                controller: question,
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: '答え'),
                controller: answer,
              )
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: answer != "" && question != "" ? () {
              Navigator.of(context).pop(true);
            } : null,
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
  if (saved != null && saved) {
    return Question(question: question.text, answer: answer.text);
  } else {
    return src;
  }
}
