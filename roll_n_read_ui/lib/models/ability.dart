enum Ability{
  dex('Dexterity'),
  wis('Wisdom'),
  int('Intelligence'),
  str('Strength'),
  cha('Charisma'),
  con('Constitution');
  
  const Ability(this.className);
  final String className;

}