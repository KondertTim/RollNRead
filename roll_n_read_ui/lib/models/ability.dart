//Abilities of a character
enum Ability{
  dex('Dexterity'),
  wis('Wisdom'),
  int('Intelligence'),
  str('Strength'),
  cha('Charisma'),
  con('Constitution');
  
  const Ability(this.abilityName);
  final String abilityName;

}