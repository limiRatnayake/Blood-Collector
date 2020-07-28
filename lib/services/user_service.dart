import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserService extends ChangeNotifier {
  Firestore _db;
  CollectionReference _ref;
  UserModel _userDetails;

  UserService() : _db = Firestore.instance {
    _ref = _db.collection(AppConstants.USERS_COLLECTION);
  }

  UserModel get userDetails => _userDetails;

  Future<DocumentSnapshot> requestUserDetails(String uid) async {
    DocumentSnapshot postSnapshot = (await _ref.document(uid).get());
    return postSnapshot;
  }

  Future<String> updateUserProfile(
    String uid,
    String firstName,
    String lastName,
    String gender,
    String birthDate,
    String bloodGroup,
    String mobileNo,
  ) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document(uid);

      await newRef.updateData({
        "firstName": firstName,
        "lastName": lastName,
        "gender": gender,
        "birthDate": birthDate,
        "bloodGroup": bloodGroup,
        "mobileNo": mobileNo,
      });
      message = "Success";
      notifyListeners();
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    return message;
  }

  
}
