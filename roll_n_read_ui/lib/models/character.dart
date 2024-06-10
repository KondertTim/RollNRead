import 'package:roll_n_read/models/class.dart';
import 'package:roll_n_read/models/ability.dart';
import 'package:roll_n_read/models/savingThrow.dart';
import 'package:roll_n_read/models/skill.dart';
import 'package:roll_n_read/models/stat.dart';

class Character{

  String name;
  ClassLabel className;
  int proficiencyBonus;

  ///Empty Character Stat List
  List<Stat> stats = List.empty();
  ///Empty saving throws proficiency List
  List<SavingThrow> savingThrows = List.empty();
  ///Empty skills proficiency List
  List<Skill> skills = List.empty();


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
    stats[index].abilityScore = value;
  }
  void setSavingThrowAt(int index){
    savingThrows[index].proficient = true;
  }
  void setStatsAt(int index){
    skills[index].proficient = true;
  }

  static List<Skill> createEmptySkillList(){
    List<Skill> createdSkills = [];
    createdSkills.add(Skill("Acrobatics", false, Ability.dex));
    createdSkills.add(Skill("Animal Handling", false, Ability.wis));
    createdSkills.add(Skill("Arcana", false, Ability.int));
    createdSkills.add(Skill("Athletics", false, Ability.str));
    createdSkills.add(Skill("Deception", false, Ability.cha));
    createdSkills.add(Skill("History", false, Ability.int));
    createdSkills.add(Skill("Insight", false, Ability.wis));
    createdSkills.add(Skill("Intimidation", false, Ability.cha));
    createdSkills.add(Skill("Investigation", false, Ability.int));
    createdSkills.add(Skill("Medicine", false, Ability.wis));
    createdSkills.add(Skill("Nature", false, Ability.int));
    createdSkills.add(Skill("Perception", false, Ability.wis));
    createdSkills.add(Skill("Performance", false, Ability.cha));
    createdSkills.add(Skill("Persuasion", false, Ability.cha));
    createdSkills.add(Skill("Religion", false, Ability.int));
    createdSkills.add(Skill("Sleight of Hand", false, Ability.dex));
    createdSkills.add(Skill("Stealth", false, Ability.dex));
    createdSkills.add(Skill("Survival", false, Ability.wis));
    return createdSkills;
  }

  static List<Stat> createEmptyStatList(){
    List<Stat> createdStats = [];
    createdStats.add(Stat("Str", Ability.str, 0));
    createdStats.add(Stat("Dex", Ability.dex, 0));
    createdStats.add(Stat("Con", Ability.con, 0));
    createdStats.add(Stat("Int", Ability.int, 0));
    createdStats.add(Stat("Wis", Ability.wis, 0));
    createdStats.add(Stat("Cha", Ability.cha, 0));
    return createdStats;
  }

  static List<SavingThrow> createEmptySavingThrowList(){
    List<SavingThrow> createdSavingThrows = [];
    createdSavingThrows.add(SavingThrow("Strength", false, Ability.str));
    createdSavingThrows.add(SavingThrow("Dexterity", false, Ability.dex));
    createdSavingThrows.add(SavingThrow("Constitution", false, Ability.con));
    createdSavingThrows.add(SavingThrow("Intelligence", false, Ability.int));
    createdSavingThrows.add(SavingThrow("Wisdom", false, Ability.wis));
    createdSavingThrows.add(SavingThrow("Charisma", false, Ability.cha));
    return createdSavingThrows;
  }
}