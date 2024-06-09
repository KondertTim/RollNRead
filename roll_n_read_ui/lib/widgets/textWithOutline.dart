import 'package:flutter/cupertino.dart';

class TextFormatting {


  Widget textWithOutline(String inputText, FontWeight fontWeight, double strokeWidth, Color outlineColor, Color mainColor, double fontSize, String fontFamily) {
    return Stack(
      children: [
        Text(
          inputText,
          style: TextStyle(
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = outlineColor,
          ),
        ),
        Text(
          inputText,
          style: TextStyle(
              fontFamily: fontFamily,
              fontWeight: fontWeight,
              color: mainColor,
              fontSize: fontSize),
        )
      ],
    );
  }
}
