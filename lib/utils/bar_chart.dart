import 'package:flutter/material.dart';
import 'package:osv2_app2/utils/math.dart';
import 'custom_colors.dart';

class BarData {
  final String title;
  final num value;
  final double max;
  final TextStyle style;

  BarData({
    required this.title,
    required this.value,
    required this.max,
    required this.style,
  });
}

Widget bar(BuildContext context, BarData barData, double height, double width) {
  double percent = barData.value / barData.max;
  if (percent > 1) percent = 1;
  double thickness = width / 4;
  double adjustedHeight = height * percent * 9 / 14;
  if (adjustedHeight < thickness) adjustedHeight = thickness;

  Color color = lerpColor(CustomColors.bar1, CustomColors.bar4, percent);


  return Container(
    width: width,
    height: height,
    alignment: Alignment.bottomCenter,
    child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("${barData.value}", style: const TextStyle(fontSize: 40, color: Colors.transparent)),
            Container(
              width: thickness,
              height: height * 9 / 14,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                // border: Border.all(width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(width/2.0)),
              ),
            ),
            Text(barData.title, style: barData.style),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("${barData.value}", style: TextStyle(fontSize: 40, color: color, fontWeight: FontWeight.bold)),
            Container(
              width: thickness,
              height: adjustedHeight,
              decoration: BoxDecoration(
                color: color,
                // border: Border.all(width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(width/2.0)),
              ),
            ),
            Text(barData.title, style: barData.style),
          ],
        )
      ],
    )
    
  );
}

Widget barChart(BuildContext context, List<BarData> bars, double height, double width) {
  return Row(
    children: bars.map((barData) => bar(context, barData, height, width)).toList(),
  );
}

class BarVisualData {
  final TextStyle valueStyle;
  final TextStyle titleStyle;
  final double thickness;
  final Color correctColor;
  final Color wrongColor;
  final Duration? animationDuration;
  

  BarVisualData({
    required this.valueStyle,
    required this.titleStyle,
    required this.thickness,
    required this.correctColor,
    required this.wrongColor,
    this.animationDuration,
  });
}

Widget improvedBarChart(
  BuildContext context, 
  List<BarData> bars, 
  BarVisualData visualData, 
  double height, 
  double width,
  ) {
  return Row(
    children: bars.map((barData) => improvedBar(context, barData, visualData, height, width)).toList(),
  );
}

Widget improvedBar(
  BuildContext context, 
  BarData barData, 
  BarVisualData visualData, 
  double height, 
  double width,
  ) {
  double percent = barData.value / barData.max;
  if (percent > 1) percent = 1;
  double dist = normDist(barData.value.toDouble(), 0.5*barData.max, 0.3*barData.max);
  // print(dist);
  Color barColor = lerpColor(visualData.wrongColor, visualData.correctColor, dist);

  TextStyle valueStyle = visualData.valueStyle;
  valueStyle = TextStyle(
    color: barColor,
    fontSize: valueStyle.fontSize,
    fontWeight: valueStyle.fontWeight
  );
  TextStyle titleStyle = visualData.titleStyle;

  double thickness = visualData.thickness;
  double adjustedMaxHeight = height - 3 * (valueStyle.fontSize!) - (titleStyle.fontSize!);
  double adjustedHeight = adjustedMaxHeight * percent;

  // if (adjustedHeight == 0) return Container(); // don't draw if value is 0?
  if (adjustedHeight < thickness) adjustedHeight = thickness;
  
  valueContainer([String? child]) {
    if (child == null) return SizedBox(width: 3 * (valueStyle.fontSize ?? 0), height: 1.5 * (valueStyle.fontSize ?? 0));
    return Container(
      width: 3 * (valueStyle.fontSize ?? 0),
      height: 1.5 * (valueStyle.fontSize ?? 0),
      alignment: Alignment.center,
      child: Text(child, style: valueStyle,),
    );
  }

  titleContainer([String? child]) {
    if (child == null) return SizedBox(width: 3 * (titleStyle.fontSize ?? 0), height: 1.5 * (titleStyle.fontSize ?? 0));
    return Container(
      width: 3 * (titleStyle.fontSize ?? 0),
      height: 1.5 * (titleStyle.fontSize ?? 0),
      alignment: Alignment.center,
      child: Text(child, style: titleStyle),
    );
  }

  return Container(
    width: width,
    height: height,
    alignment: Alignment.bottomCenter,
    child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            valueContainer(),
            Container(
              width: thickness,
              height: adjustedMaxHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.all(Radius.circular(width/2.0)),
              ),
            ),
            titleContainer(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            valueContainer("${barData.value}"),
            AnimatedContainer(
              duration: visualData.animationDuration ?? Duration.zero,
              width: thickness,
              height: adjustedHeight,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.all(Radius.circular(width/2.0)),
              ),
            ),
            titleContainer(barData.title),
          ],
        )
      ],
    )
  );
}