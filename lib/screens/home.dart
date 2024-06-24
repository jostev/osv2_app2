// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

import 'package:osv2_app2/utils/icon_button.dart';
import 'package:osv2_app2/utils/logo.dart';
import 'package:osv2_app2/utils/math.dart';
import 'package:osv2_app2/utils/bar_chart.dart';
import 'package:osv2_app2/utils/custom_colors.dart';
import 'package:osv2_app2/utils/music_buttons.dart';

import 'package:osv2_app2/services/theme_provider.dart';
import 'package:osv2_app2/services/local_services.dart';

import 'package:osv2_app2/model/poll.dart';

import 'package:osv2_app2/screens/screensaver.dart';
import 'package:osv2_app2/screens/john.dart';




const int PUMP_MODE_OFF = 100;
const int PUMP_MODE_SUPER = 102;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int john = 0;
  double ph = 1;
  double ch = 1;
  int orp = 1;
  double temp = 1;
  String? error;

  //
  // SESSION TIMER LOGIC //
  //
  final ValueNotifier<int> _duration = ValueNotifier<int>(3600);
  final Timer _timer = Timer(const Duration(seconds: 3600), () {});
  bool timerStart = false;
  
  void startTimer() {
    // session timer
    const timeInc = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer _timer = Timer.periodic(
      timeInc,
      (Timer timer) async {
        if (_duration.value == 0) {
          _duration.value = 3600;
          player.stop();
          timer.cancel();
        } else {
          _duration.value--;
        }
        if (!timerStart) {
          _duration.value = 3600;
          timer.cancel();
        }
      },
    );
  }

  //
  // PUMP TIMER LOGIC //
  //
  final ValueNotifier<int> _pumpDuration = ValueNotifier<int>(600);
  final Timer pumpTimer = Timer(const Duration(seconds: 600), () {});
  bool pumpTimerStart = false;

  void startPumpTimer() async {
    // session timer
    const timeInc = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer pumpTimer = Timer.periodic(
      timeInc,
      (Timer timer) {
        if (_pumpDuration.value == 0) {
          _pumpDuration.value = 600;
          pumpTimerStart = false;
          LocalServices().sendPostCommandRequest(
            100, 0, 0, 0, 0, 0
          );
          timer.cancel();
        } else {
          _pumpDuration.value--;
        }
        if (!pumpTimerStart) {
          _pumpDuration.value = 600;
          pumpTimerStart = false;
          LocalServices().sendPostCommandRequest(
            100, 0, 0, 0, 0, 0
          );
          timer.cancel();
        }
      },
    );
  }

  String timeToString(int seconds) {
    // converts seconds to mm:ss format
    int imin = (seconds/60).floor();
    String sec = (seconds%60).toString();
    if (sec.length == 1) {
      sec = '0$sec';
    }
    return '$imin:$sec';
  }

  final nameController = TextEditingController();

  final ValueNotifier poll = ValueNotifier(Poll(ph: 0, ch: 0, orp: 0, temp: 0, error: null));
  final ValueNotifier<bool> pollEnd = ValueNotifier<bool>(false);
  
  getData () async {
    poll.value = LocalServices().getPoll();
  }

  Timer pollTimer = Timer(const Duration(seconds: 1), () {});
  late FocusNode focusNode;
  @override void initState() {
    super.initState();
    focusNode = FocusNode();
    // pollEnd.value = !pollEnd.value;
    getData();
    pollTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) => getData());
  }

  @override
  void dispose() {
    player.dispose();
    nameController.dispose();
    _timer.cancel();
    pumpTimer.cancel();
    pollTimer.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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

    TextStyle btn1 = TextStyle(
      fontSize: SCREEN_WIDTH * 0.02, 
      color: Theme.of(context).colorScheme.primary
    );

    TextStyle btn2 = TextStyle(
      fontSize: SCREEN_WIDTH * 0.015, 
      color: Theme.of(context).hintColor
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body:
        Row(children: [ 
          Container(
            //color: Theme.of(context).colorScheme.secondary,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight, 
                end: Alignment.centerLeft, 
                colors: [
                  Theme.of(context).colorScheme.secondary, 
                  Color.lerp(
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                    0.2
                  )!
                ],
              )
            ),
            height: SCREEN_HEIGHT,
            width: SCREEN_WIDTH * 0.28,
            child: Column(children: [
              Container(
                color: Colors.transparent,
                height: SCREEN_HEIGHT * 0.50,
                width: SCREEN_WIDTH * 0.28,
                child: 
                Column(children: [
                  Divider(
                    height: SCREEN_HEIGHT * 0.03, 
                    color: Colors.transparent,
                  ),

                  //
                  // SESSION TIMER
                  //
                  ValueListenableBuilder(
                    valueListenable: _duration, 
                    builder: (context, value, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            color: Colors.transparent,
                            height: SCREEN_WIDTH * 0.21,
                            width: SCREEN_WIDTH * 0.21,
                            child: Transform.flip(
                              flipX: true,
                              child: CircularProgressIndicator(
                                value: _duration.value / 3600, 
                                backgroundColor: Colors.transparent, 
                                color: Theme.of(context).primaryColor, 
                                strokeWidth: 8
                              )
                            )
                          ),
                          Container(
                            color: Colors.transparent,
                            height: SCREEN_HEIGHT * 0.4,
                            width: SCREEN_WIDTH * 0.28,
                            child: TextButton(
                              onPressed: () {
                                if (timerStart) {
                                  _timer.cancel();
                                  player.stop();
                                  player.seek(const Duration(seconds: 0));
                                  timerStart = !timerStart;
                                } else {
                                  startTimer();
                                  player.play();
                                  timerStart = !timerStart;
                                }
                              },
                              style: TextButton.styleFrom(
                                shape: const CircleBorder()
                              ),
                              child: Text(timeToString(_duration.value), style: guage1,),
                            ),
                          ),
                      ],);
                    }
                  ),
                  
                  Divider(
                    height: SCREEN_HEIGHT * 0.017, 
                    color: Colors.transparent
                  ),
                  Text("Session Time", style: label1,)
                ],)
              ),
              
              //
              // MUSIC BUTTONS
              //

              SizedBox(
                //color: Colors.purple,
                height: SCREEN_HEIGHT * 0.5,
                width: SCREEN_WIDTH * 0.28,
                //padding: EdgeInsets.only(left: 30, right: 30, top:0, bottom: 0),
                child: 
                Column(children: [
                  Divider(
                    height: SCREEN_HEIGHT * 0.04, 
                    color: Colors.transparent,
                  ),
                  Text("Music", style: label1,),
                  Divider(
                    height: SCREEN_HEIGHT * 0.01, 
                    color: Colors.transparent,
                  ),
                  Container(
                    height: SCREEN_HEIGHT * 0.35,
                    width: SCREEN_WIDTH * 0.19,
                    //color: Colors.amber,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, 
                        end: Alignment.bottomCenter, 
                        colors: [
                          Colors.transparent, 
                          lerpColor(
                            Theme.of(context).hintColor, 
                            Colors.transparent, 
                            0.6
                          ) 
                        ],
                      )
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: buildMusicButtons(btn1, SCREEN_WIDTH, SCREEN_HEIGHT)
                      ),
                    ),
                  )
                ],)
              ),
            ],),
          ),
          
          Row(children: [
            Column(children: [
              //
              // CITY CAVE LOGO
              //
              SizedBox(
                height: SCREEN_HEIGHT * 0.15,
                width: SCREEN_WIDTH * 0.44,
                child: ccLogoThemeMode(context),
              ),
              Divider(
                height: SCREEN_HEIGHT * 0.85 * 0.5 * 0.05, 
                color: Colors.transparent,
              ),
              //
              // NAME TEXT FIELD
              //
              Container(
                height: SCREEN_HEIGHT * 0.85 * 0.3,
                width: SCREEN_WIDTH * 0.44,
                padding: const EdgeInsets.only( 
                  left: 30, 
                  right: 30, 
                  top: 0, 
                  bottom: 0
                ),
                alignment: Alignment.center,
                child: TextField(
                  cursorColor: Theme.of(context).primaryColor,
                  controller: nameController,
                  focusNode: focusNode,
                  autofocus: false, 
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50, 
                    color: Theme.of(context).hintColor, 
                    fontWeight: FontWeight.w700
                  ),
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 5
                      )
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)
                    ),
                  ),
                ),
              ),
              
              //
              // BAR GRAPH / CHART READINGS
              //
              Container(
                height: SCREEN_HEIGHT * 0.85 * 0.65,
                width: SCREEN_WIDTH * 0.44,
                padding: const EdgeInsets.only(
                  left: 30, 
                  right: 30, 
                  bottom: 30
                ),
                child:ValueListenableBuilder(
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
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return improvedBarChart(
                            context,
                            [
                              BarData(title: "PH", value: ph, max: 14, style: chart1),
                              BarData(title: "ORP", value: orp, max: 1000, style: chart1),
                              BarData(title: "CH", value: ch, max: 1000, style: chart1),
                            ], 
                            BarVisualData(
                              valueStyle: TextStyle(fontSize: 40, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700),
                              titleStyle: TextStyle(fontSize: 40, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700),
                              thickness: 20, 
                              correctColor: CustomColors.bar1, 
                              wrongColor: CustomColors.bar4
                            ),
                            SCREEN_HEIGHT * 0.85 * 0.65, 
                            SCREEN_WIDTH * 0.44 / 3 - 20
                          );
                        }
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }
                        if (snapshot.hasData) {
                          String? error = snapshot.data!.error;
                          if (error != null) {
                            return Text(error);
                          }
                          ph = snapshot.data!.ph;
                          ch = snapshot.data!.ch;
                          orp = snapshot.data!.orp;
                          temp = snapshot.data!.temp;
                          pollEnd.value = !pollEnd.value;
                          return improvedBarChart(
                            context,
                            [
                              BarData(title: "PH", value: ph, max: 14, style: chart1),
                              BarData(title: "ORP", value: orp, max: 1000, style: chart1),
                              BarData(title: "CH", value: ch, max: 1000, style: chart1),
                            ], 
                            BarVisualData(
                              valueStyle: TextStyle(fontSize: 20, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700),
                              titleStyle: TextStyle(fontSize: 20, color: Theme.of(context).hintColor, fontWeight: FontWeight.w700),
                              thickness: 20, 
                              correctColor: CustomColors.bar1, 
                              wrongColor: CustomColors.bar4
                            ),
                            SCREEN_HEIGHT * 0.85 * 0.65, 
                            SCREEN_WIDTH * 0.44 / 3 - 20
                          );
                        }
                        return const Text("No data");
                      }
                    );
                  }
                )
              ),
            ],),
            
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft, 
                  end: Alignment.centerRight, 
                  colors: [
                    Theme.of(context).colorScheme.secondary, 
                    Color.lerp(
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      0.2
                    )!
                  ],
                )
              ),
              child: Stack(
                children: [Column(children: [
                  Divider(
                    height: SCREEN_HEIGHT * 0.03, 
                    color: Colors.transparent,
                  ),
                  //
                  // WATER TEMP
                  //
                  SizedBox(
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
                            child: Text("20°C", style: guage1,), // FIX
                          ),
                          Divider(
                            height: SCREEN_HEIGHT * 0.017, 
                            color: Colors.transparent
                          ),
                          Text("Water Temp", style: label1,)
                        ],),
                      ),
                    ],),
                  ),
                  //
                  // FUNCTION BUTTONS
                  //
                  Divider(
                    height: SCREEN_HEIGHT * 0.07, 
                    color: Colors.transparent,
                  ),
                  Container(
                    height: SCREEN_HEIGHT * 0.395,
                    width: SCREEN_WIDTH * 0.28,
                    //color: Colors.amber,
                    alignment: Alignment.center,
                    child: Row(children: [
                      VerticalDivider(
                        width: SCREEN_WIDTH * 0.28 * 0.2 / 4, 
                        color: Colors.transparent,
                      ),
                      SizedBox(
                        height: SCREEN_HEIGHT * 0.4,
                        width: SCREEN_WIDTH * 0.28 * 0.8 / 3,  
                        child: Column(children: [
                          FloatingActionButton.large(
                            heroTag: "ss_btn",
                            onPressed: () {
                              SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.immersive,
                              );
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => 
                                ScreenSaver(
                                  sentDuration: _duration.value, 
                                  timerStarted: timerStart, 
                                  usersName: nameController.text,
                                  focusNode: focusNode,
                                ))
                              );
                            },
                            foregroundColor: Theme.of(context).primaryColor,
                            backgroundColor: Colors.transparent,
                            shape: CircleBorder(side: BorderSide(color: Theme.of(context).primaryColor, width: 5)),
                            elevation: 0,
                            focusElevation: 0,
                            hoverElevation: 0,
                            child: const Icon(Icons.screen_lock_landscape),
                          ),
                          const Divider(height: 9, color: Colors.transparent,),
                          Text(
                            "Screen Lock", 
                            style: btn2, 
                            textAlign: TextAlign.center
                          )
                        ],)
                      ),
                      VerticalDivider(
                        width: SCREEN_WIDTH * 0.28 * 0.2 / 4, 
                        color: Colors.transparent,
                      ),
                      SizedBox(
                        height: SCREEN_HEIGHT * 0.4,
                        width: SCREEN_WIDTH * 0.28 * 0.8 / 3,  
                        child: Column(children: [
                          FloatingActionButton.large(
                            heroTag: "mde_btn",
                            onPressed: () {
                              if (themeProvider.themeMode == ThemeMode.light) {
                                themeProvider.setThemeMode(ThemeMode.dark);
                              } else {
                                themeProvider.setThemeMode(ThemeMode.light);
                              }
                            },
                            foregroundColor: Theme.of(context).primaryColor,
                            backgroundColor: Colors.transparent,
                            shape: CircleBorder(
                              side: BorderSide(
                                color: Theme.of(context).primaryColor, 
                                width: 5
                              )
                            ),
                            elevation: 0,
                            focusElevation: 0,
                            hoverElevation: 0,
                            child: const Icon(Icons.brightness_4),
                          ),
                          const Divider(height: 9, color: Colors.transparent,),
                          Text(
                            "Toggle mode", 
                            style: btn2, 
                            textAlign: TextAlign.center
                          )
                        ],)
                      ),
                      VerticalDivider(
                        width: SCREEN_WIDTH * 0.28 * 0.2 / 4, 
                        color: Colors.transparent,
                      ),
                      SizedBox(
                        height: SCREEN_HEIGHT * 0.4,
                        width: SCREEN_WIDTH * 0.28 * 0.8 / 3,  
                        child: Column(children: [
                          ValueListenableBuilder(
                            valueListenable: _pumpDuration,
                            builder: (context, value, child) {
                              return FloatingActionButton.large(
                                heroTag: "pmp_btn",
                                onPressed: () {
                                  if (pumpTimerStart) {
                                    pumpTimer.cancel();
                                    pumpTimerStart = !pumpTimerStart;
                                    print("off");
                                    try {
                                      print("sent pump off");
                                      LocalServices().sendPostCommandRequest(
                                        PUMP_MODE_OFF, 0, 0, 0, 0, 0
                                      );
                                    } on Exception catch (e) {
                                      print(e);
                                    }
                                  } else {
                                    pumpTimerStart = !pumpTimerStart;
                                    print("on");
                                    try {
                                      print("sent pump on");
                                      LocalServices().sendPostCommandRequest(
                                        PUMP_MODE_SUPER, 0, 0, 0, 0, 0
                                      );
                                    } on Exception catch (e) {
                                      print(e);
                                    }
                                    startPumpTimer();
                                  }
                                },
                                foregroundColor: Theme.of(context).primaryColor,
                                backgroundColor: Colors.transparent,
                                shape: CircleBorder(
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor, 
                                    width: 5
                                  )
                                ),
                                elevation: 0,
                                focusElevation: 0,
                                hoverElevation: 0,
                                child: () {
                                  if (pumpTimerStart) {
                                    return Text(
                                      timeToString(_pumpDuration.value), 
                                      style: TextStyle(
                                        fontSize: 25, 
                                        color: Theme.of(context).primaryColor, 
                                        fontWeight: FontWeight.w700
                                      )
                                    );
                                  } else {
                                    return const Icon(Icons.plumbing);
                                  }
                                }(),
                              );
                            }
                          ),
                          const Divider(
                            height: 9, 
                            color: Colors.transparent,
                          ),
                          Text(
                            "Run Pump", 
                            style: btn2, 
                            textAlign: TextAlign.center
                          )
                        ],)
                      ),
                      VerticalDivider(
                        width: SCREEN_WIDTH * 0.28 * 0.2 / 4, 
                        color: Colors.transparent,
                      ),
                    ],)
                  ),
                ],),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: TextButton(
                    onPressed: () {
                      john++;
                      if (john == 30) {
                        john = 0;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Builder(builder: (BuildContext context) => John())));
                      }
                    },
                    child: mtLogoThemeMode(context),
                  ) ,
                )
            ],),
          )
        ],)
      ],),
    );
  }
}

