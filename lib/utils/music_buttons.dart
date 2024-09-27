import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'timers.dart';

List<String> music = [
  "assets/music/1HR_w_exit_track.mp3",
  "assets/music/OR_1HR.mp3",
  "assets/music/OR_10&10.mp3",
  "assets/music/evacuation.mp3"
];

List<String> musicNames = [
  "1 Hour Silence",
  "1 Hour Relaxing",
  "10 & 10 Relaxing",
  "Evacuation"
];

ValueNotifier<int> selectedSong = ValueNotifier<int>(0);
final player = AudioPlayer();

List<Function> pendingJAFunctions = [];
void addPendingJAFunction(Function function) {
  pendingJAFunctions.add(function);
}

List<Widget> buildMusicButtons(TextStyle style, double screenWidth, double screenHeight) {
  List<Widget> buttons = [];
  for (int i = 0; i < music.length; i++) {
    buttons.add(
      SizedBox(
        height: 60,
        width: screenWidth * 0.28,
        child: ValueListenableBuilder(
          valueListenable: selectedSong,
          builder: (context, value, child) {
            
            return TextButton(
              onPressed: () {
                selectedSong.value = i;
                addPendingJAFunction(() {
                  player.stop();
                  player.setAsset(music[i]);
                  player.seek(Duration(seconds: 3600 - sessionDuration.value));
                  player.setLoopMode(LoopMode.one);
                  player.play();
                });
                // player.stop();
                // player.setAsset(music[i]);
                // player.seek(Duration(seconds: 3600 - sessionDuration.value));
                // player.play();
              },
              style: TextButton.styleFrom(
                backgroundColor: () {
                  if (selectedSong.value == i) {
                    return Colors.grey;
                  } else {
                    return Theme.of(context).hintColor;
                  }
                }(),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
              ),
              child: Text(musicNames[i], style: style),
            );
          }
        )
      )
    );
    buttons.add(const Divider(height: 3, color: Colors.transparent));
  }
  return buttons;
}