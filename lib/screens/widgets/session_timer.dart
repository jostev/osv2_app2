import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:osv2_app2/utils/math.dart';
import 'package:osv2_app2/utils/music_buttons.dart';
import 'package:osv2_app2/utils/timers.dart';

var startPos = [0.0, 0.0];
var endPos = [0.0, 0.0];

Widget buildSessionTimer(BuildContext context, 
double SCREEN_HEIGHT, 
double SCREEN_WIDTH, 
AudioPlayer player) {
  TextStyle guage1 = TextStyle(
    fontSize: SCREEN_WIDTH * 0.04, 
    color: Theme.of(context).primaryColor, 
    fontWeight: FontWeight.w700
  );
  
  var strokeWidth = 12.0;

  return ValueListenableBuilder(
    valueListenable: sessionDuration, 
    builder: (context, value, child) {
      print(value);
      return Stack(
        alignment: Alignment.center,
        children: [ 
          Container(
            color: Colors.transparent,
            height: SCREEN_WIDTH * 0.21,
            width: SCREEN_WIDTH * 0.21,
            child: Transform.flip(
              flipX: true,
              child: CircularProgressIndicator(
                value: value / 3600, 
                backgroundColor: Colors.transparent, 
                color: Theme.of(context).primaryColor, 
                strokeWidth: strokeWidth
              )
            )
          ),
          Container(
            color: Colors.transparent,
            height: SCREEN_HEIGHT * 0.4,
            width: SCREEN_WIDTH * 0.28,
            child: TextButton(
              onPressed: () {
                if (timerStart) {
                  stopTimer();
                  player.stop();
                  player.seek(const Duration(seconds: 0));
                } else {
                  startTimer();
                  player.play();
                  timerStart = !timerStart;
                }
              },
              style: TextButton.styleFrom(
                shape: const CircleBorder()
              ),
              child: Text(timeToString(value), style: guage1,),
            ),
          ),
      ],);
    }
  );
}

Widget buildSessionTimer2(BuildContext context, 
double screenHeight, 
double screenWidth) {
  TextStyle guage1 = TextStyle(
    fontSize: screenWidth * 0.04, 
    color: Theme.of(context).primaryColor, 
    fontWeight: FontWeight.w700
  );
  
  var strokeWidth = 8.0;
  
  var centerPosition = [screenWidth * 0.21 * 0.69, screenWidth * 0.21 * 0.59];


  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      if (timerStart) {
        stopTimer();
        player.stop();
        player.seek(const Duration(seconds: 0));
      } else {
        startTimer();
        player.play();
        timerStart = !timerStart;
      }
    },
    onPanStart: (details) {
      startPos = [details.globalPosition.dx, details.globalPosition.dy];
      strokeWidth = 12.0;
    },
    onPanUpdate: (details) {
      endPos = [details.globalPosition.dx, details.globalPosition.dy];
      var x1 = 0;
      var y1 = -1000;
      var x2 = (endPos[0] - centerPosition[0]);
      var y2 = (endPos[1] - centerPosition[1]);
      
      var dot = x1 * x2 + y1 * y2;
      var det = x1 * y2 - y1 * x2;

      var angle = atan2(det, dot);
      if (angle < 0) {
        angle += 2 * pi;
      }
      var value = roundToNum(3600 - angle * 3600 / (2 * pi), 60);
      
      sessionDuration.value = value;
    },
    onPanEnd: (details) {
      strokeWidth = 8.0;
      if (abs(startPos[0] - endPos[0]) < 10 && abs(startPos[1] - endPos[1]) < 10) {
        if (timerStart) {
          stopTimer();
          player.stop();
          player.seek(const Duration(seconds: 0));
          print("stop");
        } else {
          startTimer();
          player.seek(Duration(seconds: 3600 - sessionDuration.value));
          player.play();
          print("play");
          timerStart = true;
        }
      } else {
        sessionTimer.cancel();
        player.stop();
        player.seek(const Duration(seconds: 0));
        print("cancel");
        startTimer();
        player.seek(Duration(seconds: 3600 - sessionDuration.value));
        player.play();
        print("play");
        timerStart = true;
      }
    },
    child: Stack(
      alignment: Alignment.center,
      children: [
        ValueListenableBuilder(
          valueListenable: sessionDuration,
          builder: (context, value, child) {
            return Container(
              color: Colors.transparent,
              height: screenWidth * 0.21,
              width: screenWidth * 0.21,
              child: Transform.flip(
                flipX: true,
                child: CircularProgressIndicator(
                  value: value / 3600,
                  backgroundColor: Colors.transparent,
                  color: Theme.of(context).primaryColor,
                  strokeWidth: strokeWidth,
                ),
              ),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: sessionDuration,
          builder: (context, value, child) {
            return Text(
              timeToString(sessionDuration.value),
              style: guage1,
            );
          },
        ),
      ],
    ),
  );
}