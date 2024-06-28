import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:osv2_app2/utils/timers.dart';

Widget buildSessionTimer(BuildContext context, 
double SCREEN_HEIGHT, 
double SCREEN_WIDTH, 
AudioPlayer player) {
  TextStyle guage1 = TextStyle(
    fontSize: SCREEN_WIDTH * 0.04, 
    color: Theme.of(context).primaryColor, 
    fontWeight: FontWeight.w700
  );
  
  return ValueListenableBuilder(
    valueListenable: sessionDuration, 
    builder: (context, value, child) {
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
                value: sessionDuration.value / 3600, 
                backgroundColor: Colors.transparent, 
                color: Theme.of(context).primaryColor, 
                strokeWidth: 8
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
                  sessionTimer.cancel();
                  player.stop();
                  player.seek(const Duration(seconds: 0));
                  timerStart = !timerStart;
                } else {
                  startTimer();
                  player.play();
                  timerStart = !timerStart;
                }
              },
              style: TextButton.styleFrom(
                shape: const CircleBorder()
              ),
              child: Text(timeToString(sessionDuration.value), style: guage1,),
            ),
          ),
      ],);
    }
  );
}