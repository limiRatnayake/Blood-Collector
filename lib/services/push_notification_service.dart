import 'dart:io';

import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/notification_model.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService extends ChangeNotifier {
  //initialize the firebase cloud messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Firestore _db;
  // Firestore _db = Firestore.instance;
  String uid;
  CollectionReference _userRef;
  CollectionReference _notificationRef;

  PushNotificationService() : _db = Firestore.instance {
    _userRef = _db.collection(AppConstants.USERS_COLLECTION);
    _notificationRef = _db.collection(AppConstants.NOTIFICATION_COLLECTION);
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
    Map<String, dynamic> tokenData;
    String tokenId;
    List<DocumentSnapshot> tokenSnapshot = (await _userRef
            .document(uid)
            .collection(AppConstants.TOKENS_COLLECTION)
            .getDocuments())
        .documents;

    for (int x = 0; x < tokenSnapshot.length; x++) {
      tokenId = tokenSnapshot[0].reference.documentID;
    }

    DocumentReference tokenRef = _userRef
        .document(uid)
        .collection(AppConstants.TOKENS_COLLECTION)
        .document(tokenId);

    tokenRef.get().then((value) async {
      tokenData = value.data;
      if (tokenData != null && tokenData.containsValue(fcmToken)) {
        print("It already containes");
      } else {
        if (fcmToken != null) {
          var tokens =
              _userRef.document(uid).collection(AppConstants.TOKENS_COLLECTION);

          await tokens.add({
            'token': fcmToken,
            'createdAt': FieldValue.serverTimestamp(),
            'platform': Platform.operatingSystem
          });
        }
      }
    });
  }

  Future<void> addNotification(
    String message,
    FirebaseUser user,
  ) async {
    try {
      final now = DateTime.now();
      final tomorrow = new DateTime(now.year, now.month, now.day + 1);
      DocumentReference newRef = _notificationRef.document();
      NotificationModel notification = NotificationModel(
          uid: user.uid,
          message: message,
          createdAt: now.toString(),
          closeOn: tomorrow.toString());
      await newRef.setData(notification.toJson());
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
