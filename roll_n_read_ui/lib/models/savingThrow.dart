import 'package:roll_n_read/models/ability.dart';

//SavingThrow of a character
class SavingThrow{
  String name;
  bool proficient;
  Ability ability;

  SavingThrow(this.name, this.proficient, this.ability);

  //Converts the class to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'proficient': proficient,
      "ability": ability.toString(),
    };
  }

  //Converts json to class
  SavingThrow.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        proficient = json['proficient'],
        ability = Ability.values.firstWhere((e) => e.toString() == json['ability']);
}