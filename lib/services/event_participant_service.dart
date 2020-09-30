import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventParticipantService extends ChangeNotifier {
  Firestore _db;
  CollectionReference _ref;
  CollectionReference _userRef;

  EventParticipantService() : _db = Firestore.instance {
    _ref = _db.collection(AppConstants.EVENTS_PARTICIPANTS_COLLECTION);
    _userRef = _db.collection(AppConstants.USERS_COLLECTION);
  }

  Future<String> addParticipants(
      FirebaseUser user, String docRef, String userName) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document();

      ParticipantModel participantModel = new ParticipantModel(
          participantId: newRef.documentID,
          docRef: docRef,
          uid: user.uid,
          participantName: userName,
          participatedStatus: "participating");
      await newRef.setData(participantModel.toJson());

      message = "Success";
      notifyListeners();
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    return message;
  }

//get user participanted evebts to history
  Future<QuerySnapshot> getParticipant(String uid) {
    return _ref.where("uid", isEqualTo: uid).getDocuments();
  }

//get participant for an particular event

  Future<QuerySnapshot> getParticipantForAnEvent(String docRef) {
    return _ref.where("docRef", isEqualTo: docRef).getDocuments();
  }

  //delete an participation event
  Future<String> updateParticipation(
      String eventId, String participatedStatus) async {
    String message = "";
    try {
      DocumentReference participantRef = _ref.document(eventId);
      await participantRef
          .updateData({"participatedStatus": participatedStatus});
      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

  // Future<DocumentSnapshot> requestParticipantDetails(String participantId) async {
  //   DocumentSnapshot postSnapshot = (await _ref.document(participantId).get());
  //   notifyListeners();
  //   return postSnapshot;
  // }
}
