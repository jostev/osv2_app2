import 'dart:async';

import 'package:flutter/material.dart';
import 'package:osv2_app2/model/poll.dart';
import 'package:osv2_app2/screens/widgets/chemical_readings.dart';
import 'package:osv2_app2/screens/widgets/function_buttons.dart';
import 'package:osv2_app2/services/mailer.dart';
import 'package:osv2_app2/utils/music_buttons.dart';


//
// SESSION TIMER LOGIC //
//
final ValueNotifier<int> sessionDuration = ValueNotifier<int>(3600);
Timer sessionTimer = Timer(const Duration(seconds: 3600), () {});
bool timerStart = false;

void timerCSVAction(poll) async {
  final pollValue = await poll.value;
  if (pollValue != null) {
    writeCSV(pollValue);
  } else {
    writeCSV(Poll(ph: 0, ch: 0, orp: 0, temp: 0, error: null, mode: 0));
    Timer(const Duration(seconds: 1), () => timerCSVAction(poll));
  }
  printCSV();
}

void startTimer() {
  // session timer
  const timeInc = Duration(seconds: 1);
  sessionDuration.value--;
  // ignore: unused_local_variable
  sessionTimer = Timer.periodic(
    timeInc,
    (Timer timer) async {
      if (sessionDuration.value == 0) {
        sessionDuration.value = 3600;
        player.stop();
        timer.cancel();
      } else {
        sessionDuration.value--;
      }
      if (!timerStart) {
        sessionDuration.value = 3600;
        timer.cancel();
      }
    },
  );
}

void stopTimer() {
  sessionTimer.cancel();
  timerStart = false;
  sessionDuration.value = 3600;
}

//
// PUMP TIMER LOGIC //
//

// pumpValues = [duration, mode]
final ValueNotifier<List<int>> pumpValues = ValueNotifier([ 600, 0 ]);
Timer pumpTimer = Timer(const Duration(seconds: 600), () {});
bool pumpTimerStart = false;

void startPumpTimer() {
  pumpTimerStart = true;
  
  sendingCommand = PUMP_MODE_SUPER;
  // session timer
  const timeInc = Duration(seconds: 1);
  // ignore: unused_local_variable
  pumpTimer = Timer.periodic(
    timeInc,
    (Timer timer) async {
      if (pumpValues.value[0] == 0) {
        // resets timer
        pumpValues.value = [600, pumpValues.value[1]];
        pumpTimerStart = false;
        // sendingCommand = 100; // sending twice

        // write values to csv file when pump timer ends
        assignPoll();
        if (pollValue != null) writeCSV(pollValue as Poll);
        printCSV();

        timer.cancel();
      } else {
        // decrements timer
        pumpValues.value = [pumpValues.value[0] - 1, pumpValues.value[1]];
      }
      if (!pumpTimerStart) {
        pumpValues.value = [600, pumpValues.value[1]];
        pumpTimerStart = false;
        sendingCommand = 100;

        // write values to csv file when pump timer ends
        assignPoll();
        if (pollValue != null) writeCSV(pollValue as Poll);
        printCSV();

        timer.cancel();
      }
    },
  );
}

void stopPumpTimer() {
  pumpTimer.cancel();
  pumpTimerStart = false;
  pumpValues.value = [600, pumpValues.value[1]];
}

String timeToString(int seconds) {
  // converts seconds to mm:ss format
  int imin = (seconds/60).floor();
  String sec = (seconds%60).toString();
  if (sec.length == 1) {
    sec = '0$sec';
  }
  return '$imin:$sec';
}

Timer pollTimer = Timer(const Duration(seconds: 1), () {});
DateTime appInitTime = DateTime.now();
// late DateTime time9;
// late DateTime time13;
// late DateTime time17;