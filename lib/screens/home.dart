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

import 'package:osv2_app2/utils/icon_button.dart';
import 'package:osv2_app2/utils/logo.dart';
import 'package:osv2_app2/utils/music_buttons.dart';
import 'package:osv2_app2/utils/timers.dart';

import 'package:osv2_app2/services/theme_provider.dart';
import 'package:osv2_app2/services/local_services.dart';
import 'package:osv2_app2/services/mailer.dart';

import 'package:osv2_app2/screens/john.dart';


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

  getData () async {
    poll.value = LocalServices().getPoll();
  }
  
  late FocusNode focusNode;
  @override void initState() {
    super.initState();
    initWriteCSV();
    focusNode = FocusNode();
    // pollEnd.value = !pollEnd.value;
    // getData();
    time9 = DateTime(
      appInitTime.year, 
      appInitTime.month,
      appInitTime.day,
      9,
    );
    time13 = DateTime(
      appInitTime.year, 
      appInitTime.month,
      appInitTime.day,
      13,
    );
    time17 = DateTime(
      appInitTime.year, 
      appInitTime.month,
      appInitTime.day,
      17,
    );
    // record 9-9.30 , 1-1.30 , 5-5.30
    
    Timer(time9.difference(DateTime.now()), () => timerCSVAction(poll));
    Timer(time13.difference(DateTime.now()), () => timerCSVAction(poll));
    Timer(time17.difference(DateTime.now()), () => timerCSVAction(poll));
    pollTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) => getData());
  }

  @override
  void dispose() {
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

    TextStyle label1 = TextStyle(
      fontSize: SCREEN_WIDTH * 0.02, 
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
            
            height: SCREEN_HEIGHT,
            width: SCREEN_WIDTH * 0.28,
            child: Column(children: [
              Container(
                color: Colors.transparent,
                height: SCREEN_HEIGHT * 0.50,
                width: SCREEN_WIDTH * 0.28,
                child: 
                Column(children: [
                  Divider(
                    height: SCREEN_HEIGHT * 0.03, 
                    color: Colors.transparent,
                  ),
                  buildSessionTimer(context, SCREEN_HEIGHT, SCREEN_WIDTH, player),
                  Divider(
                    height: SCREEN_HEIGHT * 0.017, 
                    color: Colors.transparent
                  ),
                  Text("Session Time", style: label1,)
                ],)
              ),
              buildMusicList(context, SCREEN_HEIGHT, SCREEN_WIDTH),
            ],),
          ),
          
          Row(children: [
            Column(children: [
              buildCityCaveLogo(context, SCREEN_HEIGHT, SCREEN_WIDTH),
              Divider(
                height: SCREEN_HEIGHT * 0.85 * 0.5 * 0.05, 
                color: Colors.transparent,
              ),
              buildNameTextField(context, SCREEN_HEIGHT, SCREEN_WIDTH, nameController, focusNode),
              buildChemicalReadings(context, SCREEN_HEIGHT, SCREEN_WIDTH, poll, ph, orp, ch, temp)
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
                    height: SCREEN_HEIGHT * 0.03, 
                    color: Colors.transparent,
                  ),
                  buildWaterTempMeter(context, SCREEN_HEIGHT, SCREEN_WIDTH, poll, temp),
                  buildIconButtons(context, SCREEN_HEIGHT, SCREEN_WIDTH, nameController, focusNode, themeProvider),
                  // Divider(
                  //   height: SCREEN_HEIGHT * 0.07, 
                  //   color: Colors.transparent,
                  // ),
                  buildMailButton(context, SCREEN_HEIGHT, SCREEN_WIDTH)
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

