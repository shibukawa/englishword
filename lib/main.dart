import 'dart:io';

import 'package:englishword/question.dart';
import 'package:englishword/quiz.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'えいたんご',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TopPage(),
    );
  }
}

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  var questions = <Question>[];
  var loaded = false;
  var dirpath = "";
  var error = "";

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((appDir) async {
      final path = appDir.path;
      final readFile = File("$path/question.json");
      final loaded = await _load(await readFile.readAsString());
      if (!loaded) {
        final defaultQuestions = await rootBundle.loadString('assets/question.json');
        final fail = await _load(defaultQuestions);
        if (fail) {
          setState(() {
            error = "ロードエラー";
          });
        } else {
          final writer = File("$path/question.json");
          writer.writeAsString(defaultQuestions);
        }
      }
    });
  }

  Future<bool> _load(String content) async {
    try {
      print("load");
      var loadedQuestions = await Question.load(content);
      loadedQuestions.shuffle();
      setState(() {
        questions = loadedQuestions;
        this.loaded = true;
      });
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  void _start() {
    Route route = MaterialPageRoute(builder: (context) => QuizPage(
        remained: this.questions,
        finished: [],
        duration: Duration(seconds: 0)));
    Navigator.of(context).pushReplacement(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("えいたんご"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (error != "") Text(
              error,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            if (loaded) Text(
              "スタート",
              style: Theme.of(context).textTheme.headline2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loaded ? _start : null,
        tooltip: 'Increment',
        child: const Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
