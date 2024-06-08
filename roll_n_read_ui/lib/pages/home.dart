import 'package:flutter/material.dart';
import 'package:roll_n_read/models/colorThemeList.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/dungeonWallMossy.jpg"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(2.0), // Padding to create space for the border
            decoration: BoxDecoration(
              color: Colors.black, // Border color
              borderRadius: BorderRadius.circular(180.0), // Rounded edges
            ),
            child: ClipOval(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: ColorThemeList().colors.reversed.toList(),
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
                      onPressed: (){},
                    child: const Icon(Icons.mic_outlined, size: 250,color: Colors.black,),
                  )
                ],
              ),

            ),
          )
        ),
      ),
    );
  }
}



/**
 *
 *
    width: 350,
    height: 350,
    decoration: BoxDecoration(
    shape: BoxShape.circle
    ),
    child: ElevatedButton(
    onPressed: () {  },
    style: ElevatedButton.styleFrom(
    elevation: 50,
    foregroundColor: Colors.black,
    ),
    child: const Icon(Icons.mic_outlined, size: 250),
    ),
    **/


/**
 * children: [
    SizedBox(
    height: 300,
    width: 300,
    child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: ColorThemeList().colors[0],
    foregroundColor: Colors.black
    ),
    onPressed: () {
    setState(() {
    count++;
    });
    },
    child: const Icon(Icons.mic_outlined, size: 250),
    ),
    ),
    //TextFormatting().textWithOutline("$count", FontWeight.w400, 2.5, Colors.cyanAccent, Colors.black, 40, 'DragonHunter')
    ],
 */