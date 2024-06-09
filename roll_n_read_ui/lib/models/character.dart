import 'package:roll_n_read/models/class.dart';

class Character{

  String name;
  ClassLabel className;
  int proficiencyBonus;

  ///Empty Character Stat List
  List<int> stats = List.generate(6,(index) => 1, growable: false);
  ///Empty saving throws proficiency List
  List<bool> savingThrows = List.generate(6,(index) => false, growable: false);
  ///Empty skills proficiency List
  List<bool> skills = List.generate(18,(index) => false, growable: false);


  Character(this.name, this.className, this.proficiencyBonus, this.stats,
      this.savingThrows, this.skills);

  void setName(String name){
    this.name = name;
  }
  void setClassName(ClassLabel className){
    this.className = className;
  }
  void setProficiencyBonus(int proficiencyBonus){
    this.proficiencyBonus = proficiencyBonus;
  }
  void setStatAt(int index, int value){
    stats[index] = value;
  }
  void setSavingThrowAt(int index){
    savingThrows[index] = true;
  }
  void setStatsAt(int index){
    skills[index] = true;
  }





}