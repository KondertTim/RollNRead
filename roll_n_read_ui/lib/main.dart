import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:roll_n_read/logic/voice.dart';
import 'package:roll_n_read/models/colorThemeList.dart';
import 'package:roll_n_read/widgets/textWithOutline.dart';
import 'package:roll_n_read/pages/home.dart';
import 'package:roll_n_read/pages/profile.dart';
import 'package:roll_n_read/pages/scan.dart';
import 'package:roll_n_read/pages/settings_page.dart';

Future main() async{
  await Settings.init(cacheProvider: SharePreferenceCache());
  Voice voice =  Voice();
  voice.initialize();

  runApp(const RollNRead());
}

class RollNRead extends StatefulWidget{
  const RollNRead({super.key});

  @override
  State<RollNRead> createState() => _RollNReadState();
}

class _RollNReadState extends State<RollNRead> {
  int currentPageIndex = 0;
  final screens = [
    const Home(),
    const Scan(),
    const Profile(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<bool>(
      cacheKey: SettingsPage.keyDarkMode,
      defaultValue: true,
      builder: (_, isDarkMode, __) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: isDarkMode ?  ThemeData.dark().copyWith(
                scaffoldBackgroundColor: Colors.black87,
                brightness: Brightness.dark,
                canvasColor: Colors.transparent,
                colorScheme: const ColorScheme(brightness: Brightness.dark,
                    primary: Colors.indigo,
                    onPrimary: Colors.white,
                    secondary: Colors.indigo,
                    onSecondary: Colors.black,
                    error: Colors.red,
                    onError: Colors.yellow,
                    surface: Colors.teal,
                    onSurface: Colors.white70,


                )
              )
                  :
                ThemeData.light().copyWith(
                    scaffoldBackgroundColor: Colors.white70,
                    brightness: Brightness.light,
                    canvasColor: Colors.transparent,

                ),

              home: Scaffold(
                backgroundColor: isDarkMode ? ColorThemeList().darkColors[currentPageIndex] : ColorThemeList().colors[currentPageIndex],
                appBar: AppBar(
                  backgroundColor: isDarkMode ? ColorThemeList().darkColors[currentPageIndex] : ColorThemeList().colors[currentPageIndex],
                  title: isDarkMode ? TextFormatting().textWithOutline("Roll & Read", FontWeight.w400, 2.5, Colors.white, Colors.black, 40 ,'DragonHunter'):
                  TextFormatting().textWithOutline("Roll & Read", FontWeight.w400, 6, Colors.black, Colors.white, 40 ,'DragonHunter'),
                  centerTitle: true,
                ),

                body: Container(
                  padding: const EdgeInsets.all(2.0), // Padding to create space for the border
                  decoration: BoxDecoration(
                    color: Colors.white70, // Border color
                    borderRadius: BorderRadius.circular(50.0), // Rounded edges
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: IndexedStack(
                      index: currentPageIndex,
                      children: screens,
                    ),
                  ),
                ),


                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: isDarkMode ? ColorThemeList().darkColors[currentPageIndex] : ColorThemeList().colors[currentPageIndex],
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,
                  iconSize: 35,
                  showUnselectedLabels: false,
                  items: const [
                    BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
                    BottomNavigationBarItem(label: 'Scan', icon: Icon(Icons.camera_alt_rounded)),
                    BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
                    BottomNavigationBarItem(label: 'Settings', icon: Icon(Icons.settings)),
                  ],
                  currentIndex: currentPageIndex,
                  onTap: (int index){
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                ),
              ),
            )

    );
  }
}