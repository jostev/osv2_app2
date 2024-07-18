import 'package:flutter/material.dart';
import 'package:osv2_app2/model/poll.dart';
import 'package:osv2_app2/utils/math.dart';

Widget buildWaterTempMeter(context, screenHeight, screenWidth, poll, temp) {
  TextStyle guage1 = TextStyle(
    fontSize: screenWidth * 0.04, 
    color: Theme.of(context).primaryColor, 
    fontWeight: FontWeight.w700
  );

  TextStyle label1 = TextStyle(
    fontSize: screenWidth * 0.02, 
    color: Theme.of(context).hintColor, 
    fontWeight: FontWeight.w700
  );

  return SizedBox(
    height: screenHeight * 0.5,
    width: screenWidth * 0.28,
    child: Column(children: [
      SizedBox(
        height: screenHeight * 0.5, 
        width: screenWidth * 0.28 * 0.8,
        child: Column(children: [
          Container(
            height: screenWidth * 0.21, 
            width: screenWidth * 0.21,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor, 
                width: 8
              ), 
              borderRadius: BorderRadius.all(
                Radius.circular(screenWidth * 0.21 / 2)
              )
            ),
            alignment: Alignment.center,
            child: ValueListenableBuilder(
              valueListenable: poll, 
              builder: (context, value, child) {
                return FutureBuilder<Poll?>(
                  future: poll.value, 
                  builder: (context, snapshot) {
                    String displayTemp = roundToDecimalPlace(avgList(temp), 1);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("$displayTemp°C", style: guage1,);
                    }
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      // temp = snapshot.data!.temp;
                      return Text("$displayTemp°C", style: guage1,);
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
            height: screenHeight * 0.017, 
            color: Colors.transparent
          ),
          Text("Water Temp", style: label1,)
        ],),
      ),
    ],),
  );
}