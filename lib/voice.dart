import 'dart:io';

class Voice {
  late String voice;
  Voice() {
    final voices = ["Alex", "Daniel", "Fiona", "Fred", "Karen", "Moira", "Rishi", "Samantha", "Tessa", "Veena", "Victoria"];
    voices.shuffle();
    voice = voices.first;
  }

  say(String text, {bool slow = false}) async {
    await Process.run('say', ['-v', voice, '-r', '120', text]);
  }

  saySpell(String text) async {
    if (text.contains(" ")) {
      await say(text);
    } else {
      final spell = text.split('').join(" ");
      for (var i = 0; i < spell.length; i++) {
        await Process.run('say', ['-v', voice, '-r', '150', spell[i]]);
      }
      await Future.delayed(const Duration(seconds: 1));
      await say(text);
    }
  }

  cheering() {
    final words = ["good!", "nice!", "great!", "brilliant!", "wonderful!", "amazing!", "excellent!", "fantastic!", "cool!", "tight!"];
    words.shuffle();
    say(words.first);
  }
}