import 'package:flutter/material.dart';

Widget buildNameTextField(
  BuildContext context, 
  double screenHeight, 
  double screenWidth, 
  TextEditingController nameController, 
  FocusNode focusNode
  ) {
  return Container(
    height: screenHeight * 0.85 * 0.3,
    width: screenWidth * 0.44,
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
  );
}