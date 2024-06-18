import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class John extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: SystemUiOverlay.values,
          );
          Navigator.pop(context);
        },
      child: const Scaffold(
        body: Stack(children:[
          Image(
            width: double.infinity,
            height: double.infinity,
            image: AssetImage('assets/images/huh.jpg')
          ),
          Center(
            heightFactor: 0.5,
            child: Text("John was here :)", style: TextStyle(fontSize: 40, color: Color.fromARGB(255, 255, 4, 0)),),
          )
        ,])
        
      ),
    ); 
  }
}