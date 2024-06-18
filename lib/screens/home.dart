import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osv2_app2/screens/john.dart';
import 'package:provider/provider.dart';

import 'package:osv2_app2/utils/icon_button.dart';
import 'package:osv2_app2/utils/logo.dart';
import 'package:osv2_app2/utils/math.dart';
import 'package:osv2_app2/utils/custom_bar_chart.dart';
import 'package:osv2_app2/utils/custom_colors.dart';

import 'package:osv2_app2/services/theme_provider.dart';
import 'package:osv2_app2/services/local_services.dart';
import 'package:osv2_app2/model/poll.dart';

import 'package:osv2_app2/screens/screensaver.dart';
import 'package:just_audio/just_audio.dart';


const int pumpModeOff = 100;
const int pumpModeSuper = 102;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int john = 0;
  // MUSIC PLAYER //
  List<String> music = [
    "assets/music/CC_1HR.mp3",
    "assets/music/CC_10&10.mp3",
    "assets/music/fun.mp3",
  ];
  List<String> musicNames = [
    "1 Hour",
    "10 & 10",
    "Fun",
  ];
  int selectedSong = 0;
  bool isPlaying = false;
  final player = AudioPlayer();

  void setMusic(String asset) {
    player.setAsset(asset);
  }
  List<Widget> getMusicButtons(TextStyle style) {
    List<Widget> buttons = [];
    for (int i = 0; i < music.length; i++) {
      buttons.add(
        SizedBox(
          height: 60,
          width: SCREEN_WIDTH * 0.28,
          child: TextButton(
            onPressed: () {
              _timer.cancel();
              setState(() {
                setMusic(music[i]);
                selectedSong = i;
              });
            }, 
            style: TextButton.styleFrom(
              backgroundColor: () {
                if (selectedSong == i) {
                  return Colors.grey;
                } else {
                  return Theme.of(context).hintColor;
                }
              }(),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10)
                )
              )
            ), 
            child: Text(musicNames[i], style: style),
          )
        )
      );
      buttons.add(const Divider(height: 1, color: Colors.transparent));
    }
    return buttons;
  }

  //   child: TextButton(
  //     onPressed: () {}, 
  //     style: TextButton.styleFrom(
  //       backgroundColor: Theme.of(context).hintColor,
  //     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
  //     ), 
  //     child: Text("Music", style: btn1)),
  // )

  // SESSION TIMER LOGIC //
  int _duration = 3600;
  final Timer _timer = Timer(const Duration(seconds: 3600), () {});
  bool timerStart = false;

  void startTimer() {
    // session timer
    const timeInc = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer _timer = Timer.periodic(
      timeInc,
      (Timer timer) {
        if (_duration == 0) {
          setState(() {
            _duration = 3600;
            player.stop();
            timer.cancel();
          });
        } else {
          setState(() {
            _duration--;
          });
        }
        if (!timerStart) {
          _duration = 3600;
          timer.cancel();
        }
      },
    );
  }

  // PUMP TIMER LOGIC //
  int _pumpDuration = 600;
  final Timer pumpTimer = Timer(const Duration(seconds: 600), () {});
  bool pumpTimerStart = false;

  void startPumpTimer() {
    // session timer
    const timeInc = Duration(seconds: 1);
    // ignore: unused_local_variable
    Timer pumpTimer = Timer.periodic(
      timeInc,
      (Timer timer) {
        if (_pumpDuration == 0) {
          setState(() {
            _pumpDuration = 600;
            pumpTimerStart = false;
            LocalServices().sendPostCommandRequest(
              100, 0, 0, 0, 0, 0
            );
            timer.cancel();
          });
        } else {
          setState(() {
            _pumpDuration--;
          });
        }
        if (!pumpTimerStart) {
          _pumpDuration = 600;
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
  
  //getData to update poll
  Poll? poll;
  getData () async
  {
    poll = await LocalServices().getPoll();
  }

  late FocusNode focusNode;

  @override void initState() {
    super.initState();

    focusNode = FocusNode();
  }

  @override
  void dispose() {
    player.dispose();
    nameController.dispose();
    _timer.cancel();
    pumpTimer.cancel();
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

    if (poll != null && poll!.error != null) {
      //
      // Alert Dialog (Does not work)
      //
      AlertDialog(
        title: const Text("Error"),
        content: Text(poll!.error),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: const Text("Close")
          )
        ],
      );
    } else {
      getData();
    }
    
    // default values if poll is null
    if (poll?.ph == null || poll?.orp == null || poll?.ch == null) {
      poll = Poll(ph: 5, orp: 5, ch: 5, temp: 20, error: null);
    }

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

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: Colors.transparent,
                        height: SCREEN_WIDTH * 0.21,
                        width: SCREEN_WIDTH * 0.21,
                        child: Transform.flip(
                          flipX: true,
                          child: CircularProgressIndicator(
                            value: _duration/3600, 
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
                          child: Text(timeToString(_duration), style: guage1,),
                        ),
                      ),
                  ],),
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
                        children: getMusicButtons(btn1)
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
                child: 
                Stack(children: [
                  barChartBG(context, 
                    (
                      Theme.of(context).colorScheme.secondary 
                      == CustomColors.btn1
                    ),
                    [SCREEN_WIDTH, SCREEN_HEIGHT]
                  ),
                  Row(children: [
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
                        [poll!.ph.toDouble()/100],
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
                        [poll!.orp.toDouble()],
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
                        [poll!.ch.toDouble()],
                      ),
                    ),
                  ],),
                ],)
                
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
                            child: Text("${poll!.temp}°C", style: guage1,),
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
                                  sentDuration: _duration, 
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
                          FloatingActionButton.large(
                            heroTag: "pmp_btn",
                            onPressed: () {
                              if (pumpTimerStart) {
                                pumpTimer.cancel();
                                pumpTimerStart = !pumpTimerStart;
                                try {
                                  LocalServices().sendPostCommandRequest(
                                    pumpModeOff, 0, 0, 0, 0, 0
                                  );
                                } on Exception catch (e) {
                                  print(e);
                                }
                              } else {
                                pumpTimerStart = !pumpTimerStart;
                                try {
                                  LocalServices().sendPostCommandRequest(
                                    pumpModeSuper, 0, 0, 0, 0, 0
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
                                  timeToString(_pumpDuration), 
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

