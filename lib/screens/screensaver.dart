import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
Size size = view.physicalSize / view.devicePixelRatio;


class WaveAnimation extends StatefulWidget {
  const WaveAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WaveAnimationState createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation> 
with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // sync animation with widget
      duration: const Duration(seconds: 4), // animation duration
    )..repeat(); // repeat animation back and forth
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller, 
      builder: (context, child) {
        return CustomPaint(
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height
          ),
          painter: WavePainter(_controller.value),
        );
      }
    );
  }

  @override void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override 
  void paint(Canvas canvas, Size size) {
    const black = Color.fromARGB(167, 0, 0, 0);
    final paint = Paint()
      ..color = black
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.7);


    double height = - size.height * 0.05;

    for (int i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final y = size.height * 0.6 + 10 * sin(i / size.width * 4 + animationValue * 2 * pi) - height;
      
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    // SECOND WAVE
    final paint1 = Paint()
      ..color = black
      ..style = PaintingStyle.fill;
    
    final path1 = Path();
    path1.moveTo(0, size.height);
    path1.lineTo(0, size.height * 0.7);

    for (int i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final y = size.height * 0.6 + 10 * sin(i / size.width * 4 + animationValue * 2 * pi + 400) - height;
      
      path1.lineTo(x, y);
    }

    path1.lineTo(size.width, size.height);
    path1.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint wave continuously
  }
}

class ScreenSaver extends StatefulWidget {
  final int sentDuration;
  final bool timerStarted;
  final String usersName;
  final FocusNode focusNode;

  const ScreenSaver({
    super.key, 
    required this.sentDuration, 
    required this.timerStarted, 
    required this.usersName,
    required this.focusNode
  });

  

  @override
  State<ScreenSaver> createState() => _ScreenSaverState();
}

class _ScreenSaverState extends State<ScreenSaver> 
with SingleTickerProviderStateMixin {
  ValueNotifier<int> _duration = ValueNotifier<int>(0);
  final Timer _timer = Timer(const Duration(seconds: 1), () { });

  void startTimer() {
    // ignore: unused_local_variable, no_leading_underscores_for_local_identifiers
    Timer _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_duration.value == widget.sentDuration) {
          _duration.value = widget.sentDuration - 3600;
          timer.cancel();
        } else {
          _duration.value++;
        }
        
      },
    );
  }

  
  String timeToString(int seconds) {
    //(_start/60).floor().toString()+':'+(_start - 60 * (_start/60).floor()).floor().toString()
    int imin = (seconds/60).floor();
    String sec = (seconds - 60 * imin).toString();
    if (sec.length == 1) {
      sec = '0$sec';
    }
    return '$imin:$sec';
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.timerStarted) startTimer();
    widget.usersName.replaceAll('\n', ' ');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      backgroundColor: Colors.black,
      body:GestureDetector(
        onTap: () {
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: SystemUiOverlay.values,
          );
          Navigator.pop(context);
          widget.focusNode.unfocus();
        },
        child: Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.centerLeft,
          //child: Text(timeToString(widget.sentDuration - _duration),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset("assets/images/bg_image.jpeg", fit: BoxFit.fitWidth),
              Container(color: const Color.fromARGB(77, 0, 0, 0),),
              //const WaveAnimation(),
              Column(children: [
                const Divider(height: 100, color: Colors.transparent,),
                ValueListenableBuilder(
                  valueListenable: _duration, 
                  builder: (context, value, child) {
                    return Column(children: [
                      Stack(children: [
                        SizedBox(
                          height: size.height * 0.4,
                          width: size.height * 0.4,
                          child: Transform.flip(
                            flipX: true,
                            child: CircularProgressIndicator(
                              value: (widget.sentDuration - value)/3600, 
                              color: Colors.white, strokeWidth: 3,
                            )
                          ) 
                        ),
                        Container(
                          height: size.height * 0.4,
                          width: size.height * 0.4,
                          alignment: Alignment.center,
                          child: Text(timeToString(widget.sentDuration - value), style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 60,
                            fontFamily: 'RobotoMono',
                            // fontWeight: FontWeight.w500
                          )
                        )
                        )
                      ],),
                      Divider(height: size.width * 0.1, color: Colors.transparent,),
                      () {
                        if (widget.sentDuration - value != 3600 || value == 0) {
                          return Text(
                            'Welcome', 
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: size.width * 0.03, 
                              fontFamily: 'RobotoMono',
                              // fontWeight: FontWeight.w300
                            )
                          );
                        } else {
                          return Text(
                            'Thank you, please leave a review', 
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: size.width * 0.03, 
                              fontFamily: 'RobotoMono',
                              // fontWeight: FontWeight.w300
                            )
                          );
                        }
                      }(),
                    ],);
                  }
                ),
                Text(
                  widget.usersName.replaceAll('\n', ' '), 
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: size.width * 0.08 - 16,
                    fontFamily: 'RobotoMono',
                    // fontWeight: FontWeight.w300,
                  ),
                )
              ],),
            ],) 
        ),
      )
    ); 
  }
}