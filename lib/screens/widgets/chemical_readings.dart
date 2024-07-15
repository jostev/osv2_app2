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
  double SCREEN_HEIGHT, 
  double SCREEN_WIDTH, 
  ValueNotifier<Future<Poll?>> poll, 
  List<double> ph, 
  List<int> orp, 
  List<double> ch, 
  List<double> temp
  ) {
  return Container(
    height: SCREEN_HEIGHT * 0.85 * 0.65,
    width: SCREEN_WIDTH * 0.44,
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
              valueStyle: TextStyle(fontSize: 40, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700),
              titleStyle: TextStyle(fontSize: 40, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700),
              thickness: 20, 
              correctColor: CustomColors.bar1, 
              wrongColor: CustomColors.bar4
            );
            // moving average
            List<BarData> bars = [
              BarData(title: "PH", value: avgList(ph), max: 14, style: chart1),
              BarData(title: "ORP", value: avgList(orp).toInt(), max: 1800, style: chart1),
              BarData(title: "CH", value: avgList(ch), max: 40, style: chart1),
            ];

            if (snapshot.hasData) {
              String? error = snapshot.data!.error;
              if (error != null) {
                return Text(error);
              }

              int mode = snapshot.data!.mode;
              if (mode != 2) {
                return Stack(
                  children: [
                    improvedBarChart(
                      context,
                      bars, 
                      visualData,
                      SCREEN_HEIGHT * 0.85 * 0.65, 
                      SCREEN_WIDTH * 0.44 / 3 - 20
                    ),
                    const Text("displaying old values.")
                  ],
                );
              }

              if (snapshot.data!.temp != 0) temp.add(snapshot.data!.temp);
              if (temp.length > 10) temp.remove(temp[0]);

              // add values to lists
              ph.add(snapshot.data!.ph);
              ch.add(snapshot.data!.ch);
              orp.add(snapshot.data!.orp.toInt());

              // remove old values
              if (ph.length > 10) ph.remove(ph[0]);
              if (ch.length > 10) ch.remove(ch[0]);
              if (orp.length > 10) orp.remove(orp[0]);
            }

            

            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            
            return improvedBarChart(
              context,
              bars, 
              visualData,
              SCREEN_HEIGHT * 0.85 * 0.65, 
              SCREEN_WIDTH * 0.44 / 3 - 20
            );
          }
        );
      }
    )
  );
}