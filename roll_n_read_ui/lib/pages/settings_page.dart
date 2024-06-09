import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:roll_n_read/widgets/roundIconContainer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const keyDarkMode = 'key-dark-mode';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
  }

class _SettingsPageState extends State<SettingsPage>{




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            buildDarkMode(),
            const Column(children: [
              Text("Settings")
            ],)

          ],
        )
    );
  }
  Widget buildDarkMode() => SwitchSettingsTile(
    activeColor: Colors.white,
      showDivider: true,
      leading: const RoundIconContainer(icon: Icons.dark_mode, color: Colors.indigo, iconColor: Colors.white),
      title: 'Dark Mode',
      settingKey: SettingsPage.keyDarkMode,
      onChange: (_){},
  );

}
