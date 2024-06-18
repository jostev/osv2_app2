import 'package:flutter/material.dart';
import 'package:osv2_app2/utils/get_material_color.dart';
import 'custom_colors.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: 'Ubuntu', 
  textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
  brightness: Brightness.light,
  primaryColor: getMaterialColor(CustomColors.btn2),
  
  hintColor: getMaterialColor(CustomColors.btn1),
  colorScheme: const ColorScheme.light(
    primary: CustomColors.bg1,
    secondary: Color.fromARGB(255, 244, 244, 244),
  )
);

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Ubuntu', 
  textSelectionTheme: const TextSelectionThemeData(cursorColor: Color.fromARGB(255, 34, 34, 34)),
  brightness: Brightness.dark,
  primaryColor: getMaterialColor(CustomColors.btn2),
  hintColor: getMaterialColor(CustomColors.bg2),
  highlightColor: getMaterialColor(const Color.fromARGB(255, 199, 199, 199)),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromARGB(255, 34, 34, 34),
    secondary: CustomColors.btn1,
  )
);
