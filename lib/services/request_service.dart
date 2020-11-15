import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/request_model.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class RequestAcceptenceService extends ChangeNotifier {
  Firestore _db;
  CollectionReference _ref;
  CollectionReference _participantRef;

  RequestAcceptenceService() : _db = Firestore.instance {
    _ref = _db.collection(AppConstants.EVENTS_COLLECTION);
    _participantRef =
        _db.collection(AppConstants.EVENTS_PARTICIPANTS_COLLECTION);
  }

  Future<String> addRequestDetails(
    String docRef,
    String requestStatus,
    String requestSentOn,
    String requesterId,
    bool rejected,
  ) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document();
      RequestAcceptModel reqAcceptModel = new RequestAcceptModel(
        docRef: newRef.documentID,
        requestStatus: requestStatus,
        requestSentOn: requestSentOn,
        requesterId: requesterId,
        rejected: rejected,
      );

      await newRef.setData(reqAcceptModel.toJson());
      message = "Success";
      notifyListeners();
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    return message;
  }

  Future<DocumentSnapshot> getUserRequestDetails(
      String uid, String docRef) async {
    DocumentSnapshot postSnapshot = (await _ref
        .document(docRef)
        .collection("requested")
        .document(uid)
        .get());
    notifyListeners();
    return postSnapshot;
  }

//show the event creator the list of requsters
  Future<List<RequestAcceptModel>> getRequestsList(String currentUser) async {
    List<RequestAcceptModel> _requestsList = [];
    String docRef;
    try {
      List<DocumentSnapshot> events = (await _ref
              .where("category", isEqualTo: "request")
              .where("uid", isEqualTo: currentUser)
              .getDocuments())
          .documents;

      for (int x = 0; x < events.length; x++) {
        docRef = events[0].reference.documentID;
        // docId = events[x].documentID;
        // print(docId);
        List<DocumentSnapshot> requests = (await _ref
                .document(docRef)
                .collection("requested")
                .where("rejected", isEqualTo: false)
                .getDocuments())
            .documents;

        _requestsList = requests
            .map<RequestAcceptModel>(
                (doc) => RequestAcceptModel.fromMap(doc.data))
            .toList();
      }

      notifyListeners();
      return _requestsList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //update subcollection
  Future updateRequests(String docRef, String requsterId, String requestStatus,
      bool rejectedStatus) async {
    String message = "";
    // String docRef;
    try {
      // List<DocumentSnapshot> events =
      //     (await _ref.where("category", isEqualTo: "request").getDocuments())
      //         .documents;
      // for (int x = 0; x < events.length; x++) {
      //   //to get the event documentID
      //   docRef = events[0].reference.documentID;
      //   _ref
      //       .document(docRef)
      //       .collection("requested")
      //       .getDocuments()
      //       .then((res) {
      //     res.documents.forEach((result) {
      //       _ref
      //           .document(docRef)
      //           .collection("requested")
      //           .document(requsterId)
      //           .updateData({"requestStatus": requestStatus});
      //     });
      //   });
      // }
      _ref
          .document(docRef)
          .collection("requested")
          .document(requsterId)
          .updateData(
              {"requestStatus": requestStatus, "rejected": rejectedStatus});

      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }
}
