import 'package:flutter/material.dart';
import 'package:osv2_app2/model/poll.dart';
import 'package:osv2_app2/utils/math.dart';

Widget buildWaterTempMeter(context, SCREEN_HEIGHT, SCREEN_WIDTH, poll, temp) {
  TextStyle guage1 = TextStyle(
    fontSize: SCREEN_WIDTH * 0.04, 
    color: Theme.of(context).primaryColor, 
    fontWeight: FontWeight.w700
  );

  TextStyle label1 = TextStyle(
    fontSize: SCREEN_WIDTH * 0.02, 
    color: Theme.of(context).hintColor, 
    fontWeight: FontWeight.w700
  );

  return SizedBox(
    height: SCREEN_HEIGHT * 0.5,
    width: SCREEN_WIDTH * 0.28,
    child: Column(children: [
      SizedBox(
        height: SCREEN_HEIGHT * 0.5, 
        width: SCREEN_WIDTH * 0.28 * 0.8,
        child: Column(children: [
          Container(
            height: SCREEN_WIDTH * 0.21, 
            width: SCREEN_WIDTH * 0.21,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor, 
                width: 8
              ), 
              borderRadius: BorderRadius.all(
                Radius.circular(SCREEN_WIDTH * 0.21 / 2)
              )
            ),
            alignment: Alignment.center,
            child: ValueListenableBuilder(
              valueListenable: poll, 
              builder: (context, value, child) {
                return FutureBuilder<Poll?>(
                  future: poll.value, 
                  builder: (context, snapshot) {
                    String displayTemp = roundToDecimalPlace(avgList(temp), 2);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("$displayTemp °C", style: guage1,);
                    }
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      // temp = snapshot.data!.temp;
                      return Text("$displayTemp °C", style: guage1,);
                    }
                    if (snapshot.hasError) {  
                      return Text("err", style: guage1);
                    }
                    return Text(displayTemp, style: guage1,);
                  }
                );
              }), // FIX
          ),
          Divider(
            height: SCREEN_HEIGHT * 0.017, 
            color: Colors.transparent
          ),
          Text("Water Temp", style: label1,)
        ],),
      ),
    ],),
  );
}