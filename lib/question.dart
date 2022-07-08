import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;


class Question {
  String question;
  String answer;
  int    failCount=0;
  Question({required this.question, required this.answer});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer':   answer,
    };
  }

  static Future<List<Question>> parse(String src) async {
    var questions = jsonDecode(src)['questions'] as List<dynamic>;
    return questions.map((qsrc) {
      return Question.fromJson(qsrc as Map<String, dynamic>);
    }).toList();
  }

  static save(List<Question> data) async {
    final newData = {
      "questions": data.where((Question q) => q.question != "" && q.answer != "").toList()
    };
    final json = jsonEncode(newData);
    print(json);
    final appDir = await getApplicationDocumentsDirectory();
    final path = appDir.path;
    final writeFile = File("$path/question.json");
    writeFile.writeAsString(json);
  }

  static Future<List<Question>> load() async {
    final appDir = await getApplicationDocumentsDirectory();
    final readFile = File("${appDir.path}/question.json");
    print("${appDir.path}/question.json");
    try {
      final result = await parse(await readFile.readAsString());
      result.shuffle();
      return result;
    } catch (e) {
      final result = await parse(await rootBundle.loadString('assets/question.json'));
      result.shuffle();
      return result;
    }
  }
}
