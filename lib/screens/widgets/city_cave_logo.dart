
import 'package:flutter/material.dart';
import 'package:osv2_app2/utils/logo.dart';

Widget buildCityCaveLogo(BuildContext context, double screenHeight, double screenWidth) {
  return SizedBox(
    height: screenHeight * 0.15,
    width: screenWidth * 0.44,
    child: ccLogoThemeMode(context),
  );
}
