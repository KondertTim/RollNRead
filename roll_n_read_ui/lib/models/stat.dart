import 'package:roll_n_read/models/ability.dart';

class Stat{
  String name;
  int abilityScore;
  Ability ability;

  Stat(this.name, this.ability, this.abilityScore);

  int modifier(){
    return ((abilityScore - 10.5) / 2).round();
  }
}