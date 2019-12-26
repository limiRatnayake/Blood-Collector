import 'package:flutter/material.dart';

class Technician {
  String name;
  String phoneNum;
  String address;
  double rate;
  String status;
  int rating;
  AssetImage profilePic;
  String occupation; 

  Technician(this.name, this.address, this.occupation, this.phoneNum, this.profilePic, this.rate, this.rating, this.status);
}