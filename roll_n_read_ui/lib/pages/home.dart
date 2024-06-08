import 'package:flutter/material.dart';
import 'package:roll_n_read/models/textFormating.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    count++;
                  });
                },
                child: const Icon(Icons.mic_outlined, size: 250),
              ),
            ),
            TextFormatting().textWithOutline("$count", FontWeight.w400, 2.5, Colors.cyanAccent, Colors.black, 40, 'DragonHunter')
          ],
        ),
      ),
    );
  }
}
