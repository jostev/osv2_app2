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
final Timer sessionTimer = Timer(const Duration(seconds: 3600), () {});
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
  // ignore: unused_local_variable
  Timer sessionTimer = Timer.periodic(
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

//
// PUMP TIMER LOGIC //
//
final ValueNotifier<List<int>> pumpValues = ValueNotifier([ 600, 0 ]);
final Timer pumpTimer = Timer(const Duration(seconds: 600), () {});
bool pumpTimerStart = false;

void startPumpTimer() async {
  sendingCommand = PUMP_MODE_SUPER;
  // session timer
  const timeInc = Duration(seconds: 1);
  // ignore: unused_local_variable
  Timer pumpTimer = Timer.periodic(
    timeInc,
    (Timer timer) {
      if (pumpValues.value[0] == 0) {
        pumpValues.value = [600, pumpValues.value[1]];
        pumpTimerStart = false;
        // sendingCommand = 100; // sending twice

        assignPoll();
        if (pollValue != null) writeCSV(pollValue as Poll);
        printCSV();

        timer.cancel();
      } else {
        pumpValues.value = [pumpValues.value[0] - 1, pumpValues.value[1]];
      }
      if (!pumpTimerStart) {
        pumpValues.value = [600, pumpValues.value[1]];
        pumpTimerStart = false;
        sendingCommand = 100;

        assignPoll();
        if (pollValue != null) writeCSV(pollValue as Poll);
        printCSV();

        timer.cancel();
      }
    },
  );
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