import 'package:flutter/material.dart';

class CustomColors {
  static const Color bg1 = Colors.white;
  static const Color bg2 = Color.fromARGB(255, 240, 240, 240);

  static const Color btn1 = Color.fromARGB(255, 48, 48, 48);
  // static const Color btn2 = Color.fromARGB(255, 53, 207, 209);
  static const Color btn2 = Color.fromARGB(255, 56, 163, 220);

  static const Color bar1 = Color.fromARGB(255, 14, 238, 104);
  static const Color bar2 = Color.fromARGB(255, 14, 238, 63);
  static const Color bar3 = Color.fromARGB(255, 89, 238, 14);
  static const Color bar4 = Color.fromARGB(255, 197, 238, 14);

  Color? lerpBarCol(double t) {
    List<Color> list = [bar1, bar2, bar3, bar4];
    int index = (t * list.length).toInt();
    Color c1 = list[index];
    Color c2 = list[index + 1];
    return Color.lerp(c1, c2, t);
  }
}