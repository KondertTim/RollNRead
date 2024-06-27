import 'package:flutter/material.dart';
import 'package:roll_n_read/logic/logic.dart';
import 'package:roll_n_read/logic/util.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Voice {

  bool _available = false;
  Duration listenFor = const Duration(seconds: 5);
  final SpeechToText speech = SpeechToText();
  String lastResult ="";

  //initialize speech to text only once during start
  Future<void> initialize() async {
    _available = await speech.initialize(onStatus: statusListener, onError: errorListener);
  }

  Future<Future> listen(BuildContext context) async{
    speech.listen(
        onResult: resultListener,
        listenFor: listenFor,
        localeId: 'en_US');

    await Future.delayed(const Duration(seconds: 5));
    return showDialog(context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Rolled:"),
            content: Text(lastResult),
          );
        },
    );

  }

  //Execute when recognizing speech
  //TODO: forward to either camera scanning dice or result screen
  void resultListener(SpeechRecognitionResult result) {
    print(
        'Result listener final: ${result.finalResult}, '
        'words: ${result.recognizedWords},'
    );

    if (result.finalResult){
      //set closest matching command
      Logic.command = Util.getClosestMatch(result.recognizedWords);

      //Testing with a roll of 10, can be removed
      int rollResult = Logic.getFinalPoints(10);
      int bonus = Logic.getPointsByCommand();
      print('Your roll for ${Logic.command} has a total of: $rollResult');
      lastResult = 'Your roll for ${Logic.command}: \n '
          'Roll: ${rollResult-bonus} + Modifier: $bonus = $rollResult';

    }
  }

  void errorListener(SpeechRecognitionError error){
    print('$error');
  }

  void statusListener(String status) {
    print('Received listener status: $status');
  }

}
