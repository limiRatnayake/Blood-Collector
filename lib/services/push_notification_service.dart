//library
import 'dart:io';

//models & shared widgets
import 'package:blood_collector/shared/appConstant.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService extends ChangeNotifier {
  //initialize the firebase cloud messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Firestore _db;
  // Firestore _db = Firestore.instance;
  String uid;
  CollectionReference _userRef;

  PushNotificationService() : _db = Firestore.instance {
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
      print(fcmToken);
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

  // Future<void> addNotification(
  //   String message,
  //   String bloodGroup,
  //   FirebaseUser user,
  // ) async {
  //   try {
  //     final now = DateTime.now();
  //     final tomorrow = new DateTime(now.year, now.month, now.day + 1);
  //     DocumentReference newRef = _notificationRef.document();
  //     NotificationModel notification = NotificationModel(
  //         notificationId: newRef.documentID,
  //         uid: user.uid,
  //         message: message,
  //         bloodGroup: bloodGroup,
  //         createdAt: now.toString(),
  //         closeOn: tomorrow.toString());
  //     await newRef.setData(notification.toJson());
  //   } catch (e) {
  //     print(e);
  //   }
  //   notifyListeners();
  // }

  Future<QuerySnapshot> getUserNotifications(String uid) {
    return _userRef
        .document(uid)
        .collection("user_notification")
        .orderBy("sentOn", descending: false)
        .getDocuments();
  }

//delete a notification from the us
  Future<String> deleteNotification(String uid, String userNotifyId) async {
    String message = "";
    try {
      _userRef
          .document(uid)
          .collection("user_notification")
          .document(userNotifyId)
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
