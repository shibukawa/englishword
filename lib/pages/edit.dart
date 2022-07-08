import 'package:englishword/dialogs/delete.dart';
import 'package:englishword/dialogs/save.dart';
import 'package:flutter/material.dart';

import 'package:englishword/question.dart';

import '../dialogs/edit.dart';
import '../main.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<Question>? questions;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final src = await Question.load();
    setState(() {
      questions = src;
    });
  }

  void returnToTop() async {
    final save = await openSaveConfirmDialog(context);
    if (save) {
      await Question.save(questions!);
    }
    Route route = MaterialPageRoute(builder: (context) => TopPage());
    Navigator.of(context).pushReplacement(route);
  }

  void edit(int i) async {
    final result = await openEditDialog(context, questions![i]);
    setState(() {
      questions![i] = result;
    });
  }

  void delete(int i) async {
    final result = await openDeleteDialog(context, questions![i]);
    if (result) {
      final newQuestions = questions!.toList();
      newQuestions.removeAt(i);
      setState(() {
        questions = newQuestions;
      });
    }
  }

  void add() {
    final newQuestions = questions!.toList();
    newQuestions.add(Question(question: "", answer: ""));
    setState(() {
      questions = newQuestions;
    });
  }

  void save() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("問題作り"),
        actions: [
          IconButton(icon: const Icon(Icons.home), onPressed: returnToTop),
        ],
      ),
      body: ListView.builder(
        itemCount: questions?.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              questions![index].question != "" ? questions![index].question : "(新しい問題)",
              style: TextStyle(
                color: questions![index].question != "" ? Colors.black : Colors.grey
              )
            ),
            onTap: () {
              edit(index);
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                delete(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        tooltip: '追加',
        child: const Icon(Icons.add),
      )
    );
  }
}