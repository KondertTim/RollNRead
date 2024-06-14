import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CharacterStorage {
  //Returns the local-Path
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  //Returns the local-File
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/character.json');
  }

  //Reads Character from Json-File
  static Future<String> readCharacter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return empty string
      return "";
    }
  }

  //Writes Character into a Json-File
  static Future<File> writeCharacter(String characterJson) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(characterJson);
  }
}