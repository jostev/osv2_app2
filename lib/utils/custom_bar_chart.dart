import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:osv2_app2/utils/math.dart';
import 'custom_colors.dart';

Widget getTitlesLight(double value, TitleMeta meta) {
  const style = TextStyle(
    color: CustomColors.btn1,
    fontWeight: FontWeight.w700,
    fontSize: 10, 
  );

  Widget text;
  switch (value.toInt()) {
    case 0: 
      text = const Text('PH', style: style,);
      break;
    default:
      text = const Text('');
      break;
  }

  return SideTitleWidget(
    axisSide: AxisSide.bottom,
    //space: 16,
    child: text
    );
}

Widget getTitlesDark(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 10, 
  );

  Widget text;
  switch (value.toInt()) {
    case 0: 
      text = const Text('PH', style: style,);
      break;
    default:
      text = const Text('');
      break;
  }

  return SideTitleWidget(
    axisSide: AxisSide.bottom,
    //space: 16,
    child: text
    );
}

Widget Function(double value, TitleMeta meta) getTitle(bool isDark, String title) {
  TextStyle style; 
  if (isDark) {
    style = const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25);
  } else {
    style = const TextStyle(color: CustomColors.btn1, fontWeight: FontWeight.w700, fontSize: 25);
  }

  return (double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 0: 
        text = Text(title, style: style,);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      //space: 16,
      child: text
      );
  };
}

List<BarChartGroupData> customBarChartData(List<double> values, double standardValue, List<double> se) { //VALUES FROM 0 TO 1
  List<BarChartGroupData> barGroups = [];
  for (var i = 0; i < values.length; i++) {
    double t = 1 - powd(e, -0.5 * (values[i] - standardValue) * (values[i] - standardValue) / se[i]);

    var color = lerpLAB(CustomColors.bar1, const Color.fromARGB(255, 255, 160, 77), t);
    //Color.lerp(CustomColors.bar1, const Color.fromARGB(255, 238, 115, 14), 1 - values[i]);
    barGroups.add(
      BarChartGroupData(
        x: i,
        barRods: [BarChartRodData(
          toY: roundToDecimalPlace(values[i], 1),
          width: 18,
          color: color
        )],
        showingTooltipIndicators:[0] 
      )
    );
  }

  return barGroups;
}

AxisTitles emptyAxisTitle() {
  return const AxisTitles(
    sideTitles: SideTitles(
      showTitles: false,
    ),
  );
}

BarChart customBarChart(BuildContext context, bool isDark, double maxY, double standardValue, String title, List<double> values) {
  if (values[0] > maxY) {
    maxY = values[0];
  }
  return BarChart(
    BarChartData(   
      gridData: const FlGridData(show: false),
      maxY: maxY,
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              values[0].toString(),
              TextStyle(
                color: rod.color,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            );
          },
          //getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem()// (group, groupIndex, rod, rodIndex),
        )
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitle(isDark, title), 
            reservedSize: 50,
          ),
        ),
        leftTitles: emptyAxisTitle(),
        topTitles: emptyAxisTitle(),
        rightTitles: emptyAxisTitle(),
      ),
      barGroups: customBarChartData(values, standardValue, [2, 800, 4])
    ),
  );
}

Widget barChartBG(
  BuildContext context, 
  bool isDark, 
  List<double> dimensions
) {
  List<SizedBox> barCharts = [];
  Widget emptySideTitles(double, TitleMeta) {
    return const SideTitleWidget(axisSide: AxisSide.bottom, child: Text(' '));
  }
  for (var i = 0; i < 3; i++) {
    barCharts.add(
      SizedBox(
        height: dimensions[1] * 0.85 * 0.65 - 50,
        width: dimensions[0] * 0.44 / 3 - 60 / 3,
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(show: false),
            maxY: 1,
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(enabled: false,),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: emptySideTitles,
                  reservedSize: 50,
                ),
              ),
              topTitles: emptyAxisTitle(),
              leftTitles: emptyAxisTitle(),
              rightTitles: emptyAxisTitle(),
            ),
            barGroups:[BarChartGroupData(
              x: 1, 
              barRods: [BarChartRodData(
                toY: 1, 
                width: 18, 
                color: Theme.of(context).colorScheme.secondary
              )
            ])]
          ),
        )
      )
    );
  }
  return Row(children: barCharts,);
}

Widget barChartValues(BuildContext context, double SCREEN_HEIGHT, double SCREEN_WIDTH, double ph, double ch, int orp) {
  return Row(children: [
    SizedBox(
      height: SCREEN_HEIGHT * 0.85 * 0.65 - 50,
      width: SCREEN_WIDTH * 0.44 / 3 - 60 / 3,
      child: customBarChart(
        context, 
        (
          Theme.of(context).colorScheme.secondary 
          == CustomColors.btn1
        ),
        8, // maxY
        7, // standard
        "PH",
        [ph],
      ),
    ),
    SizedBox(
      height: SCREEN_HEIGHT * 0.85 * 0.65 - 50,
      width: SCREEN_WIDTH * 0.44 / 3 - 60 / 3,
      child: customBarChart(
        context, 
        (
          Theme.of(context).colorScheme.secondary 
          == CustomColors.btn1
        ),
        900, // maxY
        800, // standard
        "ORP",
        [orp.toDouble()],
      ),
    ),
    SizedBox(
      height: SCREEN_HEIGHT * 0.85 * 0.65 - 50,
      width: SCREEN_WIDTH * 0.44 / 3 - 60 / 3,
      child: customBarChart(
        context, 
        (
          Theme.of(context).colorScheme.secondary 
          == CustomColors.btn1
        ),
        25, // maxY
        20, // standard
        "CH",
        [ch],
      ),
    ),
  ],);
}