import 'package:roll_n_read/models/ability.dart';

//Skill of a character
class Skill{
  String name;
  bool proficient;
  Ability ability;

  Skill(this.name, this.proficient, this.ability);

  //Converts the class to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'proficient': proficient,
      "ability": ability.toString(),
    };
  }

  //Converts json to class
   Skill.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        proficient = json['proficient'],
        ability = Ability.values.firstWhere((e) => e.toString() == json['ability']);
}