import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

List<String> music = [
  "assets/music/CC_1HR.mp3",
  "assets/music/CC_10&10.mp3",
  "assets/music/fun.mp3",
];
List<String> musicNames = [
  "1 Hour",
  "10 & 10",
  "Fun",
];
ValueNotifier<int> selectedSong = ValueNotifier<int>(0);
bool isPlaying = false;
final player = AudioPlayer();

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
                player.setAsset(music[i]);
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
    buttons.add(const Divider(height: 1, color: Colors.transparent));
  }
  return buttons;
}