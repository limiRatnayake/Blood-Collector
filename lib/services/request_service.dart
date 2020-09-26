import 'package:blood_collector/shared/appConstant.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventService extends ChangeNotifier {
  Firestore _db;
  CollectionReference _ref;

  EventService() : _db = Firestore.instance {
    _ref = _db.collection(AppConstants.EVENTS_COLLECTION);
  }

  Future<QuerySnapshot> getRequests(String docRef) {
    return _ref.document(docRef).collection("requested").getDocuments();
  }

  //
}
