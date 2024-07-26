// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:osv2_app2/screens/widgets/chemical_readings.dart';
import 'package:osv2_app2/screens/widgets/city_cave_logo.dart';
import 'package:osv2_app2/screens/widgets/function_buttons.dart';
import 'package:osv2_app2/screens/widgets/mail_button.dart';
import 'package:osv2_app2/screens/widgets/music_list.dart';
import 'package:osv2_app2/screens/widgets/name_field.dart';
import 'package:osv2_app2/screens/widgets/session_timer.dart';
import 'package:osv2_app2/screens/widgets/water_temp.dart';

import 'package:provider/provider.dart';

import 'package:osv2_app2/utils/logo.dart';
import 'package:osv2_app2/utils/music_buttons.dart';
import 'package:osv2_app2/utils/timers.dart';

import 'package:osv2_app2/services/theme_provider.dart';
import 'package:osv2_app2/services/local_services.dart';
import 'package:osv2_app2/services/mailer.dart';

import 'package:osv2_app2/screens/john.dart';

bool doNextPoll = true;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int john = 0;
  List<double> ph = [0];
  List<double> ch = [0];
  List<int> orp = [0];
  List<double> temp = [0];
  String? error; 

  final nameController = TextEditingController();

  nextPoll() async {
    if (sendingCommand != 0) {
      LocalServices().sendPostCommandRequest(sendingCommand, 0, 0, 0, 0, 0);
      print("Sent $sendingCommand command");
      sendingCommand = 0;
      return;
    }
    poll.value = LocalServices().getPoll();
    assignPoll();
    if (pollValue != null) {
      int mode = pollValue!.mode;
      // print(mode);
      pumpValues.value = [pumpValues.value[0], mode];
      temp.add(pollValue!.temp);
      if (temp.length > 5) {
        temp.removeAt(0);
      }
    }
  }

  late DateTime time8;
  late DateTime time13;
  late DateTime time17;

  void initCSVTimers() {
    int day = DateTime.now().day;
    
    if (DateTime.now().hour >= 9) {
      day = DateTime.now().day + 1;
    } else {
      day = DateTime.now().day;
    }
    time8 = DateTime(
      DateTime.now().year, 
      DateTime.now().month,
      day,
      8,
    );
    if (DateTime.now().hour >= 13) {
      day = DateTime.now().day + 1;
    } else {
      day = DateTime.now().day;
    }
    time13 = DateTime(
      DateTime.now().year, 
      DateTime.now().month,
      DateTime.now().day,
      13,
    );
    if (DateTime.now().hour >= 17) {
      day = DateTime.now().day + 1;
    } else {
      day = DateTime.now().day;
    }
    time17 = DateTime(
      DateTime.now().year, 
      DateTime.now().month,
      DateTime.now().day,
      17,
    );
    
    Timer(time8.difference(DateTime.now()), () {
      canSave = true;
      canSaveTimer();
    });
    Timer(time13.difference(DateTime.now()), () {
      canSave = true;
      canSaveTimer();
    });
    Timer(time17.difference(DateTime.now()), () {
      canSave = true;
      canSaveTimer();
    });
  }
  
  late FocusNode focusNode;
  @override void initState() {
    super.initState();
    initWriteCSV();
    focusNode = FocusNode();

    startAudioTimer();
    
    // nextPoll();

    // record 9-9.30 , 1-1.30 , 5-5.30
    
    initCSVTimers();
    // Timer.periodic(const Duration(days: 1), (Timer t) => initCSVTimers());
    
    LocalServices().getInfo();
    // osv2 can only handle 2 second polls
    pollTimer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      if (doNextPoll) {
        nextPoll();
      }
    });
    // pollTimer = Timer.periodic(const Duration(milliseconds: 2000), (Timer t) => nextPoll());
  }

  @override
  void dispose() {
    audioTimer.cancel();
    player.dispose();
    nameController.dispose();
    sessionTimer.cancel();
    pumpTimer.cancel();
    pollTimer.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;   

    TextStyle label1 = TextStyle(
      fontSize: screenWidth * 0.02, 
      color: Theme.of(context).hintColor, 
      fontWeight: FontWeight.w700
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body:
        Row(children: [
          Container(
            //color: Theme.of(context).colorScheme.secondary,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                focalRadius: 1,
                // begin: Alignment.centerRight, 
                // end: Alignment.centerLeft, 
                colors: [
                  Theme.of(context).colorScheme.secondary, 
                  Color.lerp(
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                    0.2
                  )!
                ],
              )
            ),
            
            height: screenHeight,
            width: screenWidth * 0.28,
            child: Column(children: [
              Container(
                color: Colors.transparent,
                height: screenHeight * 0.50,
                width: screenWidth * 0.28,
                child: 
                Column(children: [
                  Divider(
                    height: screenHeight * 0.03, 
                    color: Colors.transparent,
                  ),
                  buildSessionTimer2(context, screenHeight, screenWidth),
                  Divider(
                    height: screenHeight * 0.017, 
                    color: Colors.transparent
                  ),
                  Text("Session Time", style: label1,)
                ],)
              ),
              buildMusicList(context, screenHeight, screenWidth),
            ],),
          ),
          
          Row(children: [
            Column(children: [
              buildCityCaveLogo(context, screenHeight, screenWidth),
              Divider(
                height: screenHeight * 0.85 * 0.5 * 0.05, 
                color: Colors.transparent,
              ),
              buildNameTextField(context, screenHeight, screenWidth, nameController, focusNode),
              buildChemicalReadings(context, screenHeight, screenWidth, poll, ph, orp, ch)
            ]),
            
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.centerLeft,
                  radius: 1.5,
                  focalRadius: 1,
                  // begin: Alignment.centerLeft, 
                  // end: Alignment.centerRight, 
                  colors: [
                    Theme.of(context).colorScheme.secondary, 
                    Color.lerp(
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      0.2
                    )!
                  ],
                )
              ),
              child: Stack(
                children: [Column(children: [
                  Divider(
                    height: screenHeight * 0.03, 
                    color: Colors.transparent,
                  ),
                  buildWaterTempMeter(context, screenHeight, screenWidth, poll, temp),
                  buildIconButtons(context, screenHeight, screenWidth, nameController, focusNode, themeProvider),
                  // Divider(
                  //   height: SCREEN_HEIGHT * 0.07, 
                  //   color: Colors.transparent,
                  // ),
                  buildMailButton(context, screenHeight, screenWidth)
                ],),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: TextButton(
                    onPressed: () {
                      john++;
                      if (john == 30) {
                        john = 0;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Builder(builder: (BuildContext context) => John())));
                      }
                    },
                    child: mtLogoThemeMode(context),
                  ) ,
                )
            ],),
          )
        ],)
      ],),
    );
  }
}

