import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

class Voice {
  late FlutterTts flutterTts;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  Voice() {
    flutterTts = FlutterTts();
    initVoice();
  }

  initVoice() async {
    if (isAndroid) {
      var engine = await flutterTts.getDefaultEngine;
      if (engine != null) {
        print(engine);
      }
    }
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(1.0);
  }

  say(String text, {bool slow = false}) async {
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  saySpell(String text) async {
    if (text.contains(" ")) {
      await say(text);
    } else {
      final spell = text.split('').join(" ");
      await flutterTts.setSpeechRate(0.5);
      for (var i = 0; i < spell.length; i++) {
        await flutterTts.speak(spell[i]);
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