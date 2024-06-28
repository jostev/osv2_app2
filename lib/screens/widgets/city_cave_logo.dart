
import 'package:flutter/material.dart';
import 'package:osv2_app2/utils/logo.dart';

Widget buildCityCaveLogo(BuildContext context, double SCREEN_HEIGHT, double SCREEN_WIDTH) {
  return SizedBox(
    height: SCREEN_HEIGHT * 0.15,
    width: SCREEN_WIDTH * 0.44,
    child: ccLogoThemeMode(context),
  );
}
