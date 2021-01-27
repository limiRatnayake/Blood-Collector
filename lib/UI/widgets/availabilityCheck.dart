import 'package:flutter/material.dart';

Widget availabilityChecker(availableDate, birthDate) {
  int age;

  var selectedYear = DateTime.parse(birthDate);
  var currentYear = DateTime.now().year;

  age = (currentYear - selectedYear.year).toInt();

  return FlatButton.icon(
      onPressed: () {},
      icon: availableDate != true || age < 18 || age > 55
          ? Icon(
              Icons.stars,
              size: 15,
              color: Colors.black,
            )
          : Icon(
              Icons.stars,
              size: 15,
              color: Colors.green,
            ),
      label: Text(
        "Available to Donate",
        style: TextStyle(
            // fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.grey),
      ));
}
