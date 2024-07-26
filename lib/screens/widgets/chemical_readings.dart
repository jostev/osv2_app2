import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:osv2_app2/model/poll.dart';
import 'package:osv2_app2/utils/bar_chart.dart';
import 'package:osv2_app2/utils/custom_colors.dart';
import 'package:osv2_app2/utils/math.dart';

final ValueNotifier<Future<Poll?>> poll = ValueNotifier(Future.value(Poll(ph: 1, ch: 1, orp: 1, temp: 1, error: null, mode: 0) as Poll?));
Poll? pollValue;

void assignPoll() async {
  pollValue = await poll.value;
}

Widget buildChemicalReadings(
  BuildContext context, 
  double screenHeight, 
  double screenWidth, 
  ValueNotifier<Future<Poll?>> poll, 
  List<double> ph, 
  List<int> orp, 
  List<double> ch, 
  ) {
  return Container(
    height: screenHeight * 0.85 * 0.65,
    width: screenWidth * 0.44,
    alignment: Alignment.center,
    padding: const EdgeInsets.only(
      left: 30, 
      right: 30, 
      bottom: 30
    ),
    child: ValueListenableBuilder(
      valueListenable: poll, 
      builder: (context, value, child) {
        return FutureBuilder<Poll?>(
          future: poll.value, 
          builder: (context, snapshot) {
            TextStyle chart1 = TextStyle(
              fontSize: 30, 
              color: Theme.of(context).hintColor, 
              fontWeight: FontWeight.w700
            );
            BarVisualData visualData = BarVisualData(
              valueStyle: TextStyle(fontSize: screenHeight * 0.06, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700),
              titleStyle: TextStyle(fontSize: screenHeight * 0.06, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700),
              thickness: screenHeight * 0.85 * 0.65 * 0.05, 
              correctColor: CustomColors.bar1, 
              wrongColor: CustomColors.bar4,
              animationDuration: const Duration(milliseconds: 500),
            );
            // moving average
            List<BarData> bars = [
              BarData(title: "PH", value: avgList(ph), max: 14, style: chart1),
              BarData(title: "ORP", value: avgList(orp).toInt(), max: 1800, style: chart1),
              BarData(title: "CH", value: avgList(ch), max: 15, style: chart1),
            ];

            if (snapshot.hasData) {
              String? error = snapshot.data!.error;
              if (error != null) {
                return Stack(children: [
                  improvedBarChart(
                    context,
                    bars, 
                    visualData,
                    screenHeight * 0.85 * 0.65, 
                    clampDouble(screenWidth * 0.44 / 3 - 20, 0, double.infinity)
                  ),
                  (){
                    if (error.contains("Timeout") || snapshot.data!.ph == 0) {
                      return Container(  
                        height: screenHeight * 0.85 * 0.65 * 0.8,
                        width: screenWidth * 0.5,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(children: [
                          Text(
                            "Quick fix: Ensure this is the only tablet connected to the Mineral Swim network or try reconnecting", 
                            style: TextStyle(fontSize: screenHeight * 0.04, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700)
                          ),
                          Text(error)
                        ],)
                      );
                    }
                    return Container(  
                      height: screenHeight * 0.85 * 0.65 * 0.8,
                      width: screenWidth * 0.5,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(children: [
                        Text(
                          "Quick fix: Restart the tablet and try again", 
                          style: TextStyle(fontSize: screenHeight * 0.04, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700)
                        ),
                        Text(error)
                      ],)
                    );
                  }()
                ],);
              }

              int mode = snapshot.data!.mode;
              if (mode != 2 + 272) {
                return Stack(
                  children: [
                    improvedBarChart(
                      context,
                      bars, 
                      visualData,
                      screenHeight * 0.85 * 0.65, 
                      clampDouble(screenWidth * 0.44 / 3 - 20, 0, double.infinity)
                    ),
                    Container(
                      height: screenHeight * 0.85 * 0.65,
                      width: screenWidth * 0.44,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(
                        left: 30, 
                        right: 30, 
                        bottom: 30
                      ),
                      child: Container(  
                        height: screenHeight * 0.85 * 0.65 * 0.15,
                        width: screenWidth * 0.4,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Displaying old data", 
                          style: TextStyle(fontSize: screenHeight * 0.025, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700)
                        )
                      )
                    )
                  ],
                );
              }
              
              double chApprox = 7 * pow((snapshot.data!.orp + 100 * snapshot.data!.ph - 1263)/200, 7.87)/200;
              chApprox = clampDouble(chApprox, 0, 20);
              // add values to lists
              ph.add(snapshot.data!.ph);
              // ch.add(snapshot.data!.ch);
              if (snapshot.data!.ch > 0 || snapshot.data!.ch < 20) {
                ch.add(snapshot.data!.ch);
              } else {
                ch.add(chApprox);
              }

              orp.add(snapshot.data!.orp.toInt());

              // remove old values
              if (ph.length > 10) ph.remove(ph[0]);
              if (ch.length > 10) ch.remove(ch[0]);
              if (orp.length > 10) orp.remove(orp[0]);
            }

            
            
            // if (snapshot.hasError) {
            //   return Text("Error: ${snapshot.error}");
            // }
            
            return improvedBarChart(
              context,
              bars, 
              visualData,
              screenHeight * 0.85 * 0.65, 
              clampDouble(screenWidth * 0.44 / 3 - 20, 0, double.infinity)
            );
          }
        );
      }
    )
  );
}