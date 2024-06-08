import 'package:flutter/material.dart';
import 'package:roll_n_read/models/textFormating.dart';
import 'package:roll_n_read/pages/home.dart';
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
  int currentPageIndex = 1;
  final screens = [
    const Scan(),
    const Home(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormatting().textWithOutline("Roll & Read", FontWeight.w400, 2.5, Colors.white, Colors.black, 40 ,'DragonHunter'),
          centerTitle: true,
        ),

        body: IndexedStack(
          index: currentPageIndex,
          children: screens,
        ),


        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(label: 'Scan', icon: Icon(Icons.camera_alt_rounded)),
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
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