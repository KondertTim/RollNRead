import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:roll_n_read/logic/voice.dart';
import 'package:roll_n_read/models/colorThemeList.dart';
import 'package:roll_n_read/pages/settings_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<bool>(
      cacheKey: SettingsPage.keyDarkMode,
      defaultValue: true,
      builder: (_, isDarkMode, __) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: isDarkMode ? const AssetImage("assets/images/dungeonWallDark.jpg"):const AssetImage("assets/images/dungeonWallMossy.jpg"),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(2.0), // Padding to create space for the border
              decoration: BoxDecoration(
                color: Colors.black, // Border color
                borderRadius: BorderRadius.circular(180.0), // Rounded edges
              ),
              child: const CenterAudioButton(),
            )
          ),
        ),
      ),
    );
  }
}


/// Returns a Center-Audio-Button Widget, this class represents the UI for the
/// Audio Command Button and its onPressed-function
/// The Button design itself is a ClipOval widget in order to ensure that the
/// only the shape of the Button is clickable.
class CenterAudioButton extends StatefulWidget {
  const CenterAudioButton({
    super.key,
  });

  @override
  State<CenterAudioButton> createState() => _CenterAudioButtonState();
}

class _CenterAudioButtonState extends State<CenterAudioButton> {

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<bool>(
      defaultValue: false,
      cacheKey: SettingsPage.keyDarkMode,
      builder: (_, isDarkMode ,__) => ClipOval(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: isDarkMode ? ColorThemeList().darkColors.toList() : ColorThemeList().colors.reversed.toList(),
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter
                    )
                  ),
                )
            ),
            TextButton(
              style: TextButton.styleFrom(
                shadowColor: Colors.grey,
                elevation: 0
              ),

              onPressed: (){
                Voice voice = Voice();
                voice.listen();

                },
              child: Icon(Icons.mic_outlined, size: 250,color: isDarkMode ? Colors.black54 : Colors.white60),
            )
          ],
        ),
      ),
    );
  }
}