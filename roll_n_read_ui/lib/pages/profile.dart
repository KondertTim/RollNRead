import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:roll_n_read/logic/logic.dart';
import 'package:roll_n_read/models/character.dart';
import 'package:roll_n_read/models/savingThrow.dart';
import 'package:roll_n_read/models/skill.dart';
import 'package:roll_n_read/models/stat.dart';

import '../models/class.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<bool>(
        cacheKey: CharCreator.keyCharCreated,
        defaultValue: true,
        builder: (_, charExists, __) => Container(
            child: charExists
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Display Character"),
                      TextButton(
                          onPressed: () => setState(() {
                                Settings.setValue(
                                    CharCreator.keyCharCreated, false,
                                    notify: true);
                              }),
                          child: (const Text("Edit Character")))
                    ],
                  ),
                )
                : const CharCreator()));
  }
}

class CharDisplay extends StatefulWidget {
  const CharDisplay({
    super.key,
  });

  @override
  State<CharDisplay> createState() => _CharDisplayState();
}

class _CharDisplayState extends State<CharDisplay> {
  @override
  Widget build(BuildContext context) {
    return const Text("Profile Pork Work!");
  }
}

class CharCreator extends StatefulWidget {
  static const keyCharCreated = 'key-char-created';
  const CharCreator({
    super.key,
  });

  @override
  State<CharCreator> createState() => _CharCreatorState();
}

class _CharCreatorState extends State<CharCreator> {
  int currentStep = 0;
  bool charExists = false;

  List<Stat> stats = Character.createEmptyStatList();
  List<SavingThrow> savingThrows = Character.createEmptySavingThrowList();
  List<Skill> skills = Character.createEmptySkillList();
  int profBonus = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController statsController = TextEditingController();

  ClassLabel selectedClass = ClassLabel.paladin;

  Character? character = Logic.character;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stepper(
          type: StepperType.vertical,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            final isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep) {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  character = Character(nameController.text, selectedClass, 2,
                      stats, savingThrows, skills);
                  Logic.character = character;
                  Logic.saveCharacterAsJson();
                  Settings.setValue(CharCreator.keyCharCreated, true,
                      notify: true);
                });
              }
            } else {
              setState(() => currentStep++);
            }
          },
          onStepCancel:
              currentStep == 0 ? null : () => setState(() => currentStep--),
        ),
      );

  List<Step> getSteps() => [
        Step(
            isActive: currentStep >= 0,
            title: const Text("Character"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Name", hintText: "Grimgor Ironfist"),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton<ClassLabel>(
                  dropdownColor: Colors.white,

                  value: selectedClass,
                  //TODO: icon: ,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (ClassLabel? value) {
                    setState(() {
                      selectedClass = value!;
                    });
                  },
                  items: ClassLabel.values
                      .map<DropdownMenuItem<ClassLabel>>((ClassLabel value) {
                    return DropdownMenuItem<ClassLabel>(
                      value: value,
                      child: Text(value.className),
                    );
                  }).toList(),
                )
              ],
            )),
        Step(
            isActive: currentStep >= 1,
            title: const Text("Stats"),
            content: Column(
              children: [
                profContainer(),
                Row(
                  children: [
                    statContainer(0, "Str"),
                    statContainer(1, "Dex"),
                    statContainer(2, "Con"),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    statContainer(3, "Int"),
                    statContainer(4, "Wis"),
                    statContainer(5, "Cha"),
                  ],
                )
              ],
            )),
        Step(
            isActive: currentStep >= 2,
            title: const Text("Saving Throws"),
            content: Column(
              children: [
                savingThrowCheckbox(0, "Strength"),
                savingThrowCheckbox(1, "Dexterity"),
                savingThrowCheckbox(2, "Constitution"),
                savingThrowCheckbox(3, "Intelligence"),
                savingThrowCheckbox(4, "Wisdom"),
                savingThrowCheckbox(5, "Charisma"),
              ],
            )),
        Step(
            isActive: currentStep >= 3,
            title: const Text("Skills"),
            content: Column(
              children: [
                skillProficiencyCheckbox(0, "Acrobatics"),
                skillProficiencyCheckbox(1, "Animal Handling"),
                skillProficiencyCheckbox(2, "Arcana"),
                skillProficiencyCheckbox(3, "Athletics"),
                skillProficiencyCheckbox(4, "Deception"),
                skillProficiencyCheckbox(5, "History"),
                skillProficiencyCheckbox(6, "Insight"),
                skillProficiencyCheckbox(7, "Intimidation"),
                skillProficiencyCheckbox(8, "Investigation"),
                skillProficiencyCheckbox(9, "Medicine"),
                skillProficiencyCheckbox(10, "Nature"),
                skillProficiencyCheckbox(11, "Perception"),
                skillProficiencyCheckbox(12, "Performance"),
                skillProficiencyCheckbox(13, "Persuasion"),
                skillProficiencyCheckbox(14, "Religion"),
                skillProficiencyCheckbox(15, "Sleight of Hand"),
                skillProficiencyCheckbox(16, "Stealth"),
                skillProficiencyCheckbox(17, "Survival"),
              ],
            ))
      ];

  SizedBox savingThrowCheckbox(int index, String proficiency) {
    return SizedBox(
      width: 320,
      child: CheckboxListTile(
        title: Text(proficiency),
        value: savingThrows[index].proficient,
        onChanged: (bool? newValue) {
          setState(() {
            savingThrows[index].proficient = newValue!;
          });
        },
      ),
    );
  }

  SizedBox skillProficiencyCheckbox(int index, String proficiency) {
    return SizedBox(
      width: 320,
      child: CheckboxListTile(
        title: Text(proficiency),
        value: skills[index].proficient,
        onChanged: (bool? newValue) {
          setState(() {
            skills[index].proficient = newValue!;
          });
        },
      ),
    );
  }

  Row profContainer() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              height: 75,
              width: 200,
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/ProfBackground.png"))),
            ),
            CupertinoButton(
              padding: const EdgeInsets.only(top: 23, left: 15),
              child: Text(
                "$profBonus",
                style: const TextStyle(
                  fontFamily: "DragonHunter",
                  fontSize: 30,
                ),
              ),
              onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (_) => SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: CupertinoPicker(
                          backgroundColor: Colors.white,
                          itemExtent: 50,
                          scrollController: FixedExtentScrollController(),
                          children: List.generate(
                              10,
                              (index) => Center(
                                      child: Text(
                                    "$index", style: TextStyle(color: Colors.black),
                                  )),
                              growable: false),
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              profBonus = value;
                            });
                          },
                        ),
                      )),
            ),
          ],
        ),
      ],
    );
  }

  Container statContainer(int index, String stat) {
    return Container(
      width: 107,
      height: 153,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: AssetImage("assets/images/StatBackground.png"),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Text(
            stat,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "DragonHunter",
              fontSize: 25,
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.only(bottom: 0),
            child: Text(
              "${stats[index].abilityScore}",
              style: const TextStyle(
                fontFamily: "DragonHunter",
                fontSize: 30,
              ),
            ),
            onPressed: () => showCupertinoModalPopup(
                context: context,
                builder: (_) => SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: CupertinoPicker(
                        backgroundColor: Colors.white,
                        itemExtent: 50,
                        scrollController: FixedExtentScrollController(),
                        children: List.generate(
                            20,
                            (index) => Center(
                                    child: Text(
                                  "${index + 1}",style: TextStyle(color: Colors.black),
                                )),
                            growable: false),
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            stats[index].abilityScore = value + 1;
                          });
                        },
                      ),
                    )),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "${stats[index].modifier()}",
            style: const TextStyle(
              fontFamily: "DragonHunter",
              color: Colors.black,
              fontSize: 20,
            ),
          )
        ],
      ),
    );
  }
}
