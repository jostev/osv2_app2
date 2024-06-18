import 'package:flutter/material.dart';

Image ccLogoThemeMode(BuildContext context) {
  String path = "assets/images/white_logo.png";
  if (Theme.of(context).colorScheme.primary == Colors.white) {
    path = "assets/images/logo.png";
  }
  return Image.asset(path);
}

Image mtLogoThemeMode(BuildContext context) {
  String path = "assets/images/logo_by_maytronics_white.png";
  if (Theme.of(context).colorScheme.primary == Colors.white) {
    path = "assets/images/logo_by_maytronics.png";
  }
  return Image.asset(path, scale: 14,);
}