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
          participatedStatus: "participating",
          lastModifyDate: DateTime.now().toString());
      await newRef.setData(participantModel.toJson());

      message = "Success";
      notifyListeners();
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    return message;
  }

//get user participanted events to history
  Future<QuerySnapshot> getParticipant(String uid) {
    return _ref.where("uid", isEqualTo: uid).getDocuments();
  }

  Future<List<ParticipantModel>> getParticipantForParticularEvent(
      String docRef) async {
    try {
      List<DocumentSnapshot> snapshot =
          (await _ref.where("docRef", isEqualTo: docRef).getDocuments())
              .documents;

      List<ParticipantModel> eventParticipants = snapshot
          .map<ParticipantModel>((doc) => ParticipantModel.fromMap(doc.data))
          .toList();

      return eventParticipants;
    } catch (e) {
      print(e);
      return null;
    }
  }

//get information of a particular particpant
  Future<DocumentSnapshot> getParticipantDetails(String participantId) async {
    DocumentSnapshot postSnapshot = (await _ref.document(participantId).get());
    notifyListeners();
    return postSnapshot;
  }

  //delete an event
  Future<String> deleteAParticipant(String participantId) async {
    String message = "";
    try {
      _ref.document(participantId).delete();

      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

//get participant for an particular event

  // Future<List<UserModel>> getParticipantForAnEvent(String docRef) async {
  //   List<UserModel> _usersList = [];
  //   String uid;

  //   try {
  //     _ref.where("docRef", isEqualTo: docRef).getDocuments().then(
  //         (QuerySnapshot snapshot) =>
  //             snapshot.documents.forEach((element) async {
  //               uid = element.data["uid"];
  //               print(uid);
  //               List<DocumentSnapshot> users =
  //           (await _userRef.where("uid", isEqualTo: uid).getDocuments())
  //               .documents;

  //       _usersList =
  //           users.map<UserModel>((doc) => UserModel.fromMap(doc.data)).toList();
  //             }));

  //     // notifyListeners();
  //     return _usersList;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  // Future<List<UserModel>> getParticipantForAnEvent(String docRef) async {
  //   List<UserModel> _users;
  //   try {
  //     List<DocumentSnapshot> events =
  //         (await _ref.where("docRef", isEqualTo: docRef).getDocuments())
  //             .documents;

  //     for (int x = 0; x < events.length; x++) {
  //       String uid = events[x].data['uid'];
  //       // print(uid);
  //       // docId = events[x].documentID;
  //       // print(docId);
  //       List<DocumentSnapshot> users =
  //           (await _userRef.where("uid", isEqualTo: uid).getDocuments())
  //               .documents;

  //       _users =
  //           users.map<UserModel>((doc) => UserModel.fromMap(doc.data)).toList();
  //     }

  //     return _users;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  Future<QuerySnapshot> getParticipantForAnEvent(String docRef) {
    return _ref.where("docRef", isEqualTo: docRef).getDocuments();
  }

  //update the participating event
  Future<String> updateParticipation(String uid, String date,
      String participantId, String participatedStatus) async {
    String message = "";
    try {
      DocumentReference participantRef = _ref.document(participantId);

      await participantRef.updateData(
          {"participatedStatus": participatedStatus, "lastModifyDate": date});

      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

  //update the participating event plus user last donor selection criteria
  Future<String> updateDataOfParticipating(
      String date, String participantId, String participatedStatus) async {
    String message = "";
    try {
      DocumentReference participantRef = _ref.document(participantId);

      // Firestore.instance.runTransaction((Transaction tx) async {
      //   DocumentSnapshot docSnapshot = await tx.get(_userRef.document(uid));
      //   if (docSnapshot.exists) {
      //     await tx.update(_userRef.document(uid), <String, dynamic>{
      //       "userPreviouslyDonatedOrNot": "Yes",
      //       "dateOfLastDonation": date,
      //       "lastDonationDateCheck": false,
      //       'ifYesHowManyTimes': docSnapshot.data["ifYesHowManyTimes"] + 1
      //     });
      //   }
      // });
      await participantRef.updateData(
          {"participatedStatus": participatedStatus, "lastModifyDate": date});

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
