import 'dart:convert';
import 'dart:io';

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

  static Future<List<Question>> load(String src) async {
    var questions = jsonDecode(src)['questions'] as List<dynamic>;
    return questions.map((qsrc) {
      return Question.fromJson(qsrc as Map<String, dynamic>);
    }).toList();
  }
}
