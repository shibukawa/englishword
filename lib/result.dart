import 'package:englishword/question.dart';
import 'package:englishword/voice.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class ResultPage extends StatelessWidget {
  ResultPage({Key? key, required this.duration, required this.questions}) : super(key: key) {
    final voice = Voice();
    voice.cheering();
  }

  final List<Question> questions;
  final Duration duration;

  void returnToTop(BuildContext context) {
    Route route = MaterialPageRoute(builder: (context) => TopPage());
    Navigator.of(context).pushReplacement(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("おしまい"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text(
              "かかった時間: ${duration.inSeconds}秒",
              style: Theme.of(context).textTheme.headline3,
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { returnToTop(context); },
        tooltip: 'Increment',
        child: const Icon(Icons.home),
      ),
    );
  }
}
