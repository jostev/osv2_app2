
import 'package:flutter/material.dart';
import 'package:osv2_app2/services/mailer.dart';

Widget buildMailButton(BuildContext context, double screenHeight, double screenWidth) {
  TextStyle btn1 = TextStyle(
    fontSize: screenWidth * 0.02, 
    color: Theme.of(context).colorScheme.primary
  );

  return Container(
    height: screenHeight * 0.14,
    width: screenWidth * 0.28,
    alignment: Alignment.topCenter,
    child: Column(
      children: [
        const Divider(height: 9, color: Colors.transparent,),
        
        // const Divider(height: 9, color: Colors.transparent,),
        SizedBox(
          height: screenHeight * 0.1,
          width: screenWidth * 0.175,
          child: TextButton(
            onPressed: () async {
              sendMail();
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).hintColor,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
            ),
            child: Text("Mail", style: btn1)
          ),
        ),
      ],
    )
  );
}