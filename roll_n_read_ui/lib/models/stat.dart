import 'package:roll_n_read/models/ability.dart';

//Stats of a character
class Stat{
  String name;
  int abilityScore;
  Ability ability;

  Stat(this.name, this.ability, this.abilityScore);

  //calculates modifier by abilityScore
  int modifier(){
    return ((abilityScore - 10.5) / 2).round();
  }

  //Converts the class to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'abilityScore': abilityScore,
      "ability": ability.toString(),
    };
  }

  //Converts json to class
   Stat.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        abilityScore = json['abilityScore'],
        ability = Ability.values.firstWhere((e) => e.toString() == json['ability']);
}