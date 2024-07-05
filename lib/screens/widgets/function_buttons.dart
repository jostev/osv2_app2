import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osv2_app2/screens/screensaver.dart';
import 'package:osv2_app2/services/theme_provider.dart';
import 'package:osv2_app2/utils/timers.dart';

const int PUMP_MODE_OFF = 100;
const int PUMP_MODE_SUPER = 102;

int sendingCommand = 0;

Widget buildIconButtons(
  BuildContext context, 
  double SCREEN_HEIGHT, 
  double SCREEN_WIDTH, 
  TextEditingController nameController, 
  FocusNode focusNode, 
  ThemeProvider themeProvider) {
  TextStyle btn2 = TextStyle(
    fontSize: SCREEN_WIDTH * 0.015, 
    color: Theme.of(context).hintColor
  );
  
  return Row(children: [
    VerticalDivider(
      width: SCREEN_WIDTH * 0.28 * 0.2 / 4, 
      color: Colors.transparent,
    ),
    SizedBox(
      height: SCREEN_HEIGHT * 0.24,
      width: SCREEN_WIDTH * 0.28 * 0.8 / 3,  
      child: Column(children: [
        FloatingActionButton.large(
          heroTag: "ss_btn",
          onPressed: () {
            SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.immersive,
            );
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => 
              ScreenSaver(
                sentDuration: sessionDuration.value, 
                timerStarted: timerStart, 
                usersName: nameController.text,
                focusNode: focusNode,
              ))
            );
          },
          foregroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.transparent,
          shape: CircleBorder(side: BorderSide(color: Theme.of(context).primaryColor, width: 5)),
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          child: const Icon(Icons.screen_lock_landscape),
        ),
        const Divider(height: 9, color: Colors.transparent,),
        Text(
          "Screen Lock", 
          style: btn2, 
          textAlign: TextAlign.center
        )
      ],)
    ),
    VerticalDivider(
      width: SCREEN_WIDTH * 0.28 * 0.2 / 4, 
      color: Colors.transparent,
    ),
    SizedBox(
      height: SCREEN_HEIGHT * 0.24,
      width: SCREEN_WIDTH * 0.28 * 0.8 / 3,  
      child: Column(children: [
        FloatingActionButton.large(
          heroTag: "mde_btn",
          onPressed: () {
            if (themeProvider.themeMode == ThemeMode.light) {
              themeProvider.setThemeMode(ThemeMode.dark);
            } else {
              themeProvider.setThemeMode(ThemeMode.light);
            }
          },
          foregroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.transparent,
          shape: CircleBorder(
            side: BorderSide(
              color: Theme.of(context).primaryColor, 
              width: 5
            )
          ),
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          child: const Icon(Icons.brightness_4),
        ),
        const Divider(height: 9, color: Colors.transparent,),
        Text(
          "Toggle mode", 
          style: btn2, 
          textAlign: TextAlign.center
        )
      ],)
    ),
    VerticalDivider(
      width: SCREEN_WIDTH * 0.28 * 0.2 / 4, 
      color: Colors.transparent,
    ),
    SizedBox(
      height: SCREEN_HEIGHT * 0.24,
      width: SCREEN_WIDTH * 0.28 * 0.8 / 3,  
      child: Column(children: [
        ValueListenableBuilder(
          valueListenable: pumpValues,
          builder: (context, value, child) {
            return FloatingActionButton.large(
              heroTag: "pmp_btn",
              onPressed: () {
                if (pumpTimerStart) {
                  pumpTimer.cancel();
                  pumpTimerStart = !pumpTimerStart;
                  sendingCommand = PUMP_MODE_OFF; 
                } else {
                  pumpTimerStart = !pumpTimerStart;
                  sendingCommand = PUMP_MODE_SUPER;
                  startPumpTimer();
                }
              },
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.transparent,
              shape: CircleBorder(
                side: BorderSide(
                  color: Theme.of(context).primaryColor, 
                  width: 5
                )
              ),
              elevation: 0,
              focusElevation: 0,
              hoverElevation: 0,
              child: () {
                Color color = Theme.of(context).primaryColor;

                if (pumpValues.value[1] == 2) {
                  color = Colors.green;
                } else if (pumpValues.value[1] == 1) {
                  color = Colors.purple;
                } else if (pumpValues.value[1] == 0) {
                  color = Theme.of(context).primaryColor;
                } else {
                  color = Colors.red;
                }

                if (pumpTimerStart) {
                  return Text(
                    timeToString(pumpValues.value[0]), 
                    style: TextStyle(
                      fontSize: 25, 
                      color: color, 
                      fontWeight: FontWeight.w700
                    )
                  );
                } else {
                  return Icon(Icons.plumbing, color: color);
                }
              }(),
            );
          }
        ),
        const Divider(
          height: 9, 
          color: Colors.transparent,
        ),
        Text(
          "Run Pump", 
          style: btn2, 
          textAlign: TextAlign.center
        )
      ],)
    ),
    VerticalDivider(
      width: SCREEN_WIDTH * 0.28 * 0.2 / 4, 
      color: Colors.transparent,
    ),
  ],);
}