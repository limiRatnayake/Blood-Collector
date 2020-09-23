import 'package:blood_collector/models/participant_model.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventParticipantService extends ChangeNotifier {
  Firestore _db;
  CollectionReference _ref;

  EventParticipantService() : _db = Firestore.instance {
    _ref = _db.collection(AppConstants.EVENTS_PARTICIPANTS_COLLECTION);
  }

  Future<String> addParticipants(
      FirebaseUser user, String docRef, String userName) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document();

      ParticipantModel participantModel = new ParticipantModel(
          docRef: docRef, uid: user.uid, participantName: userName);
      await newRef.setData(participantModel.toJson());

      message = "Success";
      notifyListeners();
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    return message;
  }

  Future<QuerySnapshot> getParticipant(String uid) {
    return _ref.where("uid", isEqualTo: uid).getDocuments();
  }

   Future<QuerySnapshot> getParticipantEvents(String docRef) {
    return Firestore.instance.collection("events").where("docRef", isEqualTo: docRef).getDocuments();
  }

  // Future<DocumentSnapshot> requestParticipantDetails(String participantId) async {
  //   DocumentSnapshot postSnapshot = (await _ref.document(participantId).get());
  //   notifyListeners();
  //   return postSnapshot;
  // }
}
