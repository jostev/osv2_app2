import 'package:flutter/material.dart';
import 'package:osv2_app2/utils/custom_colors.dart';
import 'package:osv2_app2/utils/get_material_color.dart';

class ThemeDataStyle {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Ubuntu', 
    brightness: Brightness.light,
    primaryColor: getMaterialColor(CustomColors.btn2),
    
    hintColor: getMaterialColor(CustomColors.btn1),
    colorScheme: const ColorScheme.light(
      primary: CustomColors.bg1,
      secondary: CustomColors.bg2,
    )
  );

  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Ubuntu', 
    brightness: Brightness.dark,
    primaryColor: getMaterialColor(CustomColors.btn2),
    hintColor: getMaterialColor(CustomColors.bg2),
    highlightColor: getMaterialColor(const Color.fromARGB(255, 199, 199, 199)),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 34, 34, 34),
      secondary: CustomColors.btn1,
    )
  );
}