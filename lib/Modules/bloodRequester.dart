import 'package:flutter/material.dart';

class BloodRequester {
  String name;
  String phoneNum;
  String address;
  String bType;
  AssetImage profilePic;
  

  BloodRequester(
    this.name,
    this.address,
    this.phoneNum,
    this.profilePic,
    this.bType
  );
}
