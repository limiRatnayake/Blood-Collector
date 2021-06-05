//library
import 'dart:io';

//models & shared widgets
import 'package:blood_collector/shared/appConstant.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PushNotificationService extends ChangeNotifier {
  //initialize the firebase cloud messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseFirestore _db;
  // Firestore _db = Firestore.instance;
  String uid;
  CollectionReference _userRef;

  PushNotificationService() : _db = FirebaseFirestore.instance {
    _userRef = _db.collection(AppConstants.USERS_COLLECTION);
  }
  //get device token from user login to homescreen
  Future getDeviceToken(String uid, BuildContext context) async {
    this.uid = uid;
    if (Platform.isIOS) {
      _firebaseMessaging.onIosSettingsRegistered.listen((data) {
        print(data);
        _saveDeviceToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }
  }

  _saveDeviceToken() async {
    String fcmToken = await _firebaseMessaging.getToken();

    // Save the initial token to the database
    await saveToken(fcmToken);

    // Any time the token refreshes, store this in the database too.
    _firebaseMessaging.onTokenRefresh.listen(saveToken);
  }

  Future<void> saveToken(String token) async {
    var tokenRef = await _userRef
        .doc(uid)
        .collection(AppConstants.TOKENS_COLLECTION)
        .doc(token)
        .set({
      'tokens': token,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem
    });
  }

  Future<QuerySnapshot> getUserNotifications(String uid) {
    return _userRef
        .doc(uid)
        .collection("user_notification")
        .orderBy("sentOn", descending: false)
        .get();
  }

//delete a notification from the us
  Future<String> deleteNotification(String uid, String userNotifyId) async {
    String message = "";
    try {
      _userRef
          .doc(uid)
          .collection("user_notification")
          .doc(userNotifyId)
          .delete();

      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }
}
