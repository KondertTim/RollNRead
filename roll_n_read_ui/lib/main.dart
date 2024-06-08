import 'package:flutter/material.dart';
import 'package:roll_n_read/models/colorThemeList.dart';
import 'package:roll_n_read/models/textFormatting.dart';
import 'package:roll_n_read/pages/home.dart';
import 'package:roll_n_read/pages/profile.dart';
import 'package:roll_n_read/pages/scan.dart';
import 'package:roll_n_read/pages/settings.dart';

void main() {
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
    const Settings(),
  ];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ColorThemeList().colors[currentPageIndex],
        appBar: AppBar(
          backgroundColor: ColorThemeList().colors[currentPageIndex],
          title: TextFormatting().textWithOutline("Roll & Read", FontWeight.w400, 2.5, Colors.white, Colors.black, 40 ,'DragonHunter'),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(

            )
          ),
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
          backgroundColor: ColorThemeList().colors[currentPageIndex],
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
    );
  }
}