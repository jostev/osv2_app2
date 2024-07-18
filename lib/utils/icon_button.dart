import 'dart:ui';
import 'package:flutter/material.dart';
import 'custom_colors.dart';

FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
Size size = view.physicalSize / view.devicePixelRatio;

Widget customIconButton(Icon icon, String text, TextStyle style, double screenWidth, double screenHeight) {
  return SizedBox(
    height: screenHeight * 0.85 * 0.4,
    width: screenWidth * 0.77 * 0.55* 0.23,
    child: Column(children: [
      FloatingActionButton.large(
        onPressed: (){},
        foregroundColor: CustomColors.btn2,
        backgroundColor: Colors.transparent,
        shape: const CircleBorder(side: BorderSide(color: CustomColors.btn2, width: 5)),
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        child: icon,
      ),
      const Divider(height: 9, color: Colors.transparent,),
      Text(text, style: style,)
    ],)
  );
}