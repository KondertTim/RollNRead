import 'package:roll_n_read/logic/logic.dart';
import 'package:roll_n_read/logic/util.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Voice {

  bool _available = false;
  Duration listenFor = const Duration(seconds: 5);
  final SpeechToText speech = SpeechToText();
  Future<void> initialize() async {
    _available = await speech.initialize(onStatus: statusListener, onError: errorListener);
  }

  void listen(){
    speech.listen(
        onResult: resultListener,
        listenFor: listenFor,
        localeId: 'en_US');
  }

  void resultListener(SpeechRecognitionResult result) {
    print(
        'Result listener final: ${result.finalResult}, '
        'words: ${result.recognizedWords},'
    );

    if (result.finalResult){
      Logic.command = Util.getClosestMatch(result.recognizedWords);
      int rollResult = Logic.getFinalPoints(10);
      print('Your roll for ${Logic.command} has a total of: $rollResult');
    }


  }

  void errorListener(SpeechRecognitionError error){
    print('$error');
  }

  void statusListener(String status) {
    print('Received listener status: $status');
  }

}
