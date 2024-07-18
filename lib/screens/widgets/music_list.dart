
import 'package:flutter/material.dart';
import 'package:osv2_app2/utils/math.dart';
import 'package:osv2_app2/utils/music_buttons.dart';

Widget buildMusicList(BuildContext context, double screenHeight, double screenWidth) {
  TextStyle label1 = TextStyle(
    fontSize: screenWidth * 0.02, 
    color: Theme.of(context).hintColor, 
    fontWeight: FontWeight.w700
  );

  TextStyle btn1 = TextStyle(
    fontSize: screenWidth * 0.02, 
    color: Theme.of(context).colorScheme.primary
  );

  return SizedBox(
    //color: Colors.purple,
    height: screenHeight * 0.5,
    width: screenWidth * 0.28,
    //padding: EdgeInsets.only(left: 30, right: 30, top:0, bottom: 0),
    child: 
    Column(children: [
      Divider(
        height: screenHeight * 0.04, 
        color: Colors.transparent,
      ),
      Text("Music", style: label1,),
      Divider(
        height: screenHeight * 0.01, 
        color: Colors.transparent,
      ),
      Container(
        height: screenHeight * 0.35,
        width: screenWidth * 0.19,
        //color: Colors.amber,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter, 
        //     end: Alignment.bottomCenter, 
        //     colors: [
        //       Colors.transparent, 
        //       lerpColor(
        //         Theme.of(context).hintColor, 
        //         Colors.transparent, 
        //         0.6
        //       ) 
        //     ],
        //   )
        // ),
        child: SingleChildScrollView(
          child: Column(
            children: buildMusicButtons(btn1, screenHeight, screenWidth)
          ),
        ),
      )
    ],)
  );
}