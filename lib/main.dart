import 'package:flutter/material.dart'; // dependencies
import 'package:flutter/services.dart';
import 'package:osv2_app2/screens/home.dart'; // screen
// ignore: unused_import
import 'package:osv2_app2/screens/connect.dart'; // screen
import 'package:osv2_app2/utils/theme_data_style.dart'; // utils
import 'package:provider/provider.dart';
import 'services/theme_provider.dart';

import 'dart:io'; 
import 'package:flutter/foundation.dart'; 

//
// WAYS TO BUILD
//
// flutter run --enable-impeller (speeds up rendering, off by default on 
// android)
// flutter run --release (release mode)

//
// TODO LIST
//
// Find out how to reduce number of lines in home.dart
// ValueNotifiers or providers?
// reduce build time for music buttons
//
// LATER
//
// Finish screen for connecting to osv2
// Remove extra libraries (just_audio_windows)


void main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft, 
        DeviceOrientation.landscapeRight
      ]
    );

    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: 
        Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: ThemeDataStyle.lightTheme,
            darkTheme: ThemeDataStyle.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen()
          );
        }));
  }
}
