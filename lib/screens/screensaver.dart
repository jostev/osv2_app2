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
  _WaveAnimationState createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation> 
with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // sync animation with widget
      duration: Duration(seconds: 4), // animation duration
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
    final paint = Paint()
      ..color = Color.fromARGB(192, 0, 0, 0)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.7);


    double height = - size.height * 0.05;
    double increment = size.width/ 4;

    for (int i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final y = size.height * 0.6 + 10 * sin(i / size.width * 4 + animationValue * 2 * pi) - height;
      
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    // SECOND WAVE
    final paint1 = Paint()
      ..color = Color.fromARGB(146, 0, 0, 0)
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

  const ScreenSaver({
    super.key, 
    required this.sentDuration, 
    required this.timerStarted, 
    required this.usersName
  });

  

  @override
  State<ScreenSaver> createState() => _ScreenSaverState();
}

class _ScreenSaverState extends State<ScreenSaver> 
with SingleTickerProviderStateMixin {
  int _duration = 0;
  final Timer _timer = Timer(const Duration(seconds: 1), () { });
  bool timerStart = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (timerStart & widget.timerStarted) {
      timerStart = false;
      startTimer();
    }
    return Scaffold(
      body:GestureDetector(
        onTap: () {
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: SystemUiOverlay.values,
          );
          timerStart = true;
          Navigator.pop(context);
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
            WaveAnimation(),
            Column(children: [
              const Divider(height: 100, color: Colors.transparent,),
              Stack(children: [
                SizedBox(
                  height: size.height * 0.4,
                  width: size.height * 0.4,
                  child: Transform.flip(
                    flipX: true,
                    child: CircularProgressIndicator(
                      value: (widget.sentDuration - _duration)/3600, 
                      color: Colors.white, strokeWidth: 3,
                    )
                  ) 
                ),
                Container(
                  height: size.height * 0.4,
                  width: size.height * 0.4,
                  alignment: Alignment.center,
                  child: Text(timeToString(widget.sentDuration - _duration), style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 60,
                    fontWeight: FontWeight.w300
                  )
                )
                )
              ],),
              const Divider(height: 100, color: Colors.transparent,),
              () {
                if (widget.sentDuration - _duration != 3600) {
                  return const Text(
                    'Welcome', 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 30, 
                      fontWeight: FontWeight.w300
                    )
                  );
                } else {
                  return const Text(
                    'Thank you for your time', 
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 30, 
                      fontWeight: FontWeight.w300
                    )
                  );
                }
              }(),
              Text(
                widget.usersName.replaceAll('\n', ' '), 
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 80,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],),
          ],) 
        ),
      )
    ); 
  }

  void startTimer() {
    // ignore: unused_local_variable
    Timer _timer = Timer.periodic(
      const Duration(milliseconds: 1),
      (Timer timer) {
        if (_duration == widget.sentDuration || timerStart) {
          setState(() {
            _duration = widget.sentDuration - 3600;
            timer.cancel();
          });
        } else {
          setState(() {
            _duration += 1;
          });
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
}