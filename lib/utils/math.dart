import "dart:math";
import "dart:ui";
import "package:flutter/material.dart";
import 'package:flutter_color_models/flutter_color_models.dart';

double root(double x, double n) {
  if (n == 0 || n.isNaN) {
    return 1;
  }
  double r = x * n;
  for (var i = 0; i < 10; i++) {
    r = (r + x/r)*n;
  }
  return r;
}

double powd(double x, double n) {
  double r = root(x, n - n.floorToDouble());
  if (n > 0) {
    for (var i = 0; i < n.floor(); i++) {
      r *= x;
    }
  } else {
    for (var i = n.floor(); i < 0; i++) {
      r /= x;
    }
  }
  return r;
}

double lerpDouble(double a, double b, double t) {
  double r = a + (b - a) * t;
  if (t > 1) {
    r = b;
  }else if (t < 0 || t.isNaN) {
    r = a;
  }
  //print(r);
  return r;
}

Color lerpLAB(Color a, Color b, double t) {
  LabColor labA = LabColor.fromColor(a);
  LabColor labB = LabColor.fromColor(b);
  LabColor lab = LabColor(
    lerpDouble(labA.lightness.toDouble(), labB.lightness.toDouble(), t),
    lerpDouble(labA.a.toDouble(), labB.a.toDouble(), t),
    lerpDouble(labA.b.toDouble(), labB.b.toDouble(), t),
  );
  return lab.toColor();
}

Color lerpColor(Color a, Color b, double t) {
  return Color.lerp(a, b, t)!;
}

double intNoise(double x) {
  return (sin(2 * x) + sin(pi * x)) / 2;
}

double roundToDecimalPlace(double x, int n) {
  return  (x * pow(10, n)).roundToDouble()/pow(10, n);
}

double abs(double x) {
  return x < 0 ? -x : x;
}

double normDist(double x, double m, double se) {
  double xa = abs((x-m)/se);
  if (xa < 1) {
    return 1 - 0.4*xa*xa;
  } else if (xa < 3) {
    return 0.15*(xa - 3)*(xa - 3);
  }
  return 0;
}
