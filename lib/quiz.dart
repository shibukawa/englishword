import 'package:englishword/question.dart';
import 'package:englishword/result.dart';
import 'package:englishword/voice.dart';
import 'package:flutter/material.dart';

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
  var indicator = "";
  var mistake = false;
  var finish = false;
  final start = DateTime.now();
  var duration = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();
    indicator = createIndicator(0);
    _controller = new TextEditingController();
  }

  String createIndicator(int count) {
    var indicatorSrc = [""];
    for (var i = 0; i < count; i++) {
      indicatorSrc.add("●");
    }
    for (var i = count; i < widget.question.answer.length; i++) {
      if (widget.question.answer[i] == ' ') {
        indicatorSrc.add("_");
      } else {
        indicatorSrc.add("○");
      }
    }
    return indicatorSrc.join();
  }

  onChange(String text) async {
    if (widget.question.answer == text) {
      setState(() {
        duration = DateTime.now().difference(start);
        indicator = createIndicator(text.length);
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
    } else if (widget.question.answer.startsWith(text)) {
      setState(() {
        indicator = createIndicator(text.length);
      });
    } else {
      setState(() {
        mistake = true;
        _controller.text = text.substring(0, text.length-1);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.finished.length + 1} / ${widget.remained.length + widget.finished.length}"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Center(child: Text(
            widget.question.question,
            style: Theme.of(context).textTheme.headline2,
          )),
          SizedBox(height: 30),
          Divider(),
          SizedBox(height: 30),
          Center(
            child: Text(
              indicator,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'こたえ',
              ),
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