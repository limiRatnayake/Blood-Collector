import 'package:flutter/material.dart';

BoxDecoration boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(40.0),
    boxShadow: [
      BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(3, 6)) //BoxShadow
    ]);
BoxDecoration settingData = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
          color: Colors.black12,
          blurRadius: 3,
          offset: Offset(2, 8)) //BoxShadow
    ]);

const inputDecoration = InputDecoration(
    hintStyle: TextStyle(
      fontSize: 16.0,
      fontFamily: "Roboto",
    ),
    border: InputBorder.none,
    enabledBorder: InputBorder.none);
