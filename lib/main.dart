import 'dart:io';

import 'package:englishword/pages/edit.dart';
import 'package:englishword/question.dart';
import 'package:englishword/pages/quiz.dart';
import 'package:flutter/material.dart';

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
  var dirpath = "";
  var error = "";

  @override
  void initState() {
    super.initState();
  }

  void _start() async {
    late List<Question> loadedQuestions;
    try {
      loadedQuestions = await Question.load();
      loadedQuestions.shuffle();
    } catch (e) {
      setState(() {
        this.error = e.toString();
      });
      return;
    }

    Route route = MaterialPageRoute(builder: (context) => QuizPage(
        remained: loadedQuestions,
        finished: [],
        duration: Duration(seconds: 0)));
    Navigator.of(context).pushReplacement(route);
  }

  void moveToEdit() {
    Route route = MaterialPageRoute(builder: (context) => EditPage());
    Navigator.of(context).pushReplacement(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("えいたんご"),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: moveToEdit),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (error != "") Text(
              error,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              "スタート",
              style: Theme.of(context).textTheme.headline2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _start,
        tooltip: 'スタート',
        child: const Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
