import 'dart:convert';
import 'dart:math';
import 'package:roll_n_read/logic/characterStorage.dart';
import 'package:roll_n_read/models/ability.dart';
import 'package:roll_n_read/models/character.dart';
import 'package:roll_n_read/models/stat.dart';

class Logic{
  //Character 
  static Character? character;
  //Actual voice command
  static String command = "";

  //Return final points
  static int getFinalPoints(int rolled){
    //gets points by voic command, adds the number of dice and returns 
    return getPointsByCommand() + rolled;
  }

  //Returns points by voice command
  static int getPointsByCommand(){
    if(character != null){
      //iterate through savingThrows list and search for the voice command
      for (var savingThrow in character!.savingThrows) {
        if(savingThrow.name.toLowerCase() == command.toLowerCase()){
          //if there is a match, get the modifier points
          int points = getModifierPointsByAbility(savingThrow.ability);
          //if the savingThrow is proficient, then add the proficiencyBonus
          if(savingThrow.proficient == true){
            points += character!.proficiencyBonus;
          }

          return points;
        }
      }

      //if the voic command was not found, then search in the skills
      //iterate through skills list and search for the voice command
      for (var skill in character!.skills) {
        if(skill.name.toLowerCase() == command.toLowerCase()){
          //if there is a match, get the modifier points
          int points = getModifierPointsByAbility(skill.ability);
          //if the skill is proficient, then add the proficiencyBonus
          if(skill.proficient == true){
            points += character!.proficiencyBonus;
          }

          return points;
        }
      }
    }

    return 0;
  }

  //Returns points by ability
  static int getModifierPointsByAbility(Ability ability){
    int points = 0;

    if(character != null){
      Stat stat = character!.stats.where((i) => i.ability == ability).first;
      points = stat.modifier();
    }

    return points;
  }

  //Saves the character into a json File
  static Future<void> saveCharacterAsJson() async {
    var characterJson = jsonEncode(character!.toJson());
    await CharacterStorage.writeCharacter(characterJson);
  }

  //Reads the character from a json File
  static Future<Character?> readCharacterFromJson() async{
      try {
        var characterJson = await CharacterStorage.readCharacter();
        Map<String, dynamic> j = jsonDecode(characterJson);
        Character c = Character.fromJson(j);
        character = c;
        return character;
      } catch (e) {
        print("Error: ${e}");
        return null;
      }
  }
}