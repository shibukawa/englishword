import 'package:flutter/material.dart';

import 'package:englishword/question.dart';
import 'package:englishword/pages/result.dart';
import 'package:englishword/voice.dart';
import 'package:englishword/main.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.remained, required this.finished, required this.duration}) : super(key: key);

  final List<Question> remained;
  final List<Question> finished;
  final Duration duration;

  Question get question {
    return remained.first;
  }

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late TextEditingController _controller;
  var mistake = false;
  var matchedLength = 0;
  final List<bool> mistakes = [];
  var finish = false;
  final start = DateTime.now();
  var duration = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    for (var i = 0; i < widget.question.answer.length; i++) {
      mistakes.add(false);
    }
  }
  
  RichText indicator() {
    if (finish) {
      return createAnswerText();
    } else {
      return createIndicator();
    }
  }

  TextSpan indicatorChild(int i, String s, bool finished) {
    return TextSpan(
      text: s,
      style: TextStyle(
        fontSize: 40,
        color: mistakes[i] ? Colors.red : finished ? Colors.black : Colors.black26
      ),
    );
  }

  RichText createIndicator() {
    final spans = <TextSpan>[];
    for (var i = 0; i < widget.question.answer.length; i++) {
      final finished = (i < matchedLength);
      if (widget.question.answer[i] == ' ') {
        spans.add(indicatorChild(i, "_", finished));
      } else if (widget.question.answer[i] == '.') {
        spans.add(indicatorChild(i, ".", finished));
      } else if (widget.question.answer[i] == '?') {
        spans.add(indicatorChild(i, "?", finished));
      } else {
        spans.add(indicatorChild(i, finished ? "●" : "○", finished));
      }
    }
    return RichText(
      text: TextSpan(
        text: "",
        style: Theme.of(context).textTheme.headline4,
        children: spans,
      )
    );
  }

  RichText createAnswerText() {
    /*final words = widget.question.answer.split(RegExp(r"\s+"));
    final syllableMatch = RegExp(r"/[^aeiouy]*[aeiouy]+(?:[^aeiouy]*$|[^aeiouy](?=[^aeiouy]))?");
    for (var word in words) {
      final syllables = syllableMatch.allMatches(word);
      print("$word, ${syllables}");
      for (var i = 0; i < syllables.length; i++) {
        print("${i}: ${syllables.elementAt(i)}");
      }
    }*/
    final spans = <TextSpan>[];
    for (var i = 0; i < widget.question.answer.length; i++) {
      spans.add(indicatorChild(i, widget.question.answer[i], true));
    }

    return RichText(
      text: TextSpan(
        text: "",
        style: Theme.of(context).textTheme.headline4,
        children: spans,
      ),
    );
  }

  onFinish() async {
    setState(() {
      duration = DateTime.now().difference(start);
    });
    final voice = Voice();
    if (mistake) {
      await voice.saySpell(widget.question.answer);
    } else {
      await voice.say(widget.question.answer);
    }
    setState(() {
      finish = true;
    });
  }

  onChange(String text) async {
    if (widget.question.answer == text) {
      onFinish();
    } else if (widget.question.answer.startsWith(text)) {
      setState(() {
        matchedLength = text.length;
      });
    } else {
      setState(() {
        mistake = true;
        _controller.text = text.substring(0, text.length-1);
        mistakes[text.length-1] = true;
        _controller.selection = TextSelection(
          baseOffset: text.length-1,
          extentOffset: text.length-1);
      });
    }
  }

  onNext() {
    if (mistake) {
      widget.remained.first.failCount++;
      widget.remained.shuffle();
      Route route = MaterialPageRoute(builder: (context) => QuizPage(
          remained: widget.remained,
          finished: widget.finished,
          duration: duration + widget.duration));
      Navigator.of(context).pushReplacement(route);
    } else if (widget.remained.length == 1) {
      final ok = widget.remained.first;
      final finished = widget.finished.sublist(0);
      finished.add(ok);
      Route route = MaterialPageRoute(builder: (context) => ResultPage(
          questions: finished,
          duration: duration + widget.duration));
      Navigator.of(context).pushReplacement(route);
    } else {
      final ok = widget.remained.first;
      final remained = widget.remained.sublist(1);
      final finished = widget.finished.sublist(0);
      finished.add(ok);
      Route route = MaterialPageRoute(builder: (context) => QuizPage(
          remained: remained,
          finished: finished,
          duration: duration + widget.duration));
      Navigator.of(context).pushReplacement(route);
    }
  }

  void returnToTop() {
    Route route = MaterialPageRoute(builder: (context) => TopPage());
    Navigator.of(context).pushReplacement(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.finished.length + 1} / ${widget.remained.length + widget.finished.length}"),
        actions: [
          IconButton(icon: const Icon(Icons.home), onPressed: returnToTop),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text(
            widget.question.question,
            style: Theme.of(context).textTheme.headline2,
          )),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 30),
          Center(
            child: indicator(),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'こたえ',
              ),
              style: const TextStyle(fontSize: 36.0),
              readOnly: finish,
              onChanged: onChange,
            ),
          ),
        ],
      ),
      floatingActionButton: finish ? FloatingActionButton(
        onPressed: onNext,
        tooltip: 'もどる',
        child: const Icon(Icons.play_arrow),
      ) : null,
    );
  }
}