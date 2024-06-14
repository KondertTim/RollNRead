import 'package:dartlang_utils/dartlang_utils.dart';
import 'package:roll_n_read/models/character.dart';
import 'package:roll_n_read/models/savingThrow.dart';
import '../models/skill.dart';

class Util {
  static int levenshteinMax = 20;
  static List<Skill> skills = Character.createEmptySkillList();
  static List<SavingThrow> saves = Character.createEmptySavingThrowList();

  //Match voice command to closest check/save using levenshtein distance
  static String getClosestMatch(String command) {
    int minDistance = levenshteinMax;
    String closestMatch = "";
    for (var save in saves) {
      int distance = StringUtils.levenshteinDistance(command, save.name);
      if (distance < minDistance) {
        minDistance = distance;
        closestMatch = save.name;
      }
    }
    for (var skill in skills){
      int distance = StringUtils.levenshteinDistance(command, skill.name);
      if (distance < minDistance){
        minDistance = distance;
        closestMatch = skill.name;
      }
    }
    return closestMatch;
  }
}
