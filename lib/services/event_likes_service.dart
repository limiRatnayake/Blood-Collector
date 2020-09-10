import 'dart:io';

import 'package:blood_collector/models/event_likes_model.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventLikesService extends ChangeNotifier {
  Firestore _db;
  CollectionReference _ref;

  EventLikesService() : _db = Firestore.instance {
    _ref = _db.collection(AppConstants.EVENTS_COLLECTION);
  }


  Future<void> setPostLikes(String docRef, String uid, bool isLiked) async {
    try {
      DocumentReference newRef =
          _ref.document(docRef).collection(AppConstants.EVENTS_LIKES_COLLECTION).document(uid);
      EventLikesModel likesModel = new EventLikesModel(docRef: docRef);
      await newRef.setData(likesModel.toJson());
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future<DocumentSnapshot> getEventLiked(String docRef) async {
    DocumentSnapshot likesSnapshot = (await _ref.document(docRef).collection(AppConstants.EVENTS_LIKES_COLLECTION).document().get());
    notifyListeners();
    return likesSnapshot;
  }
  
  // Future<List<EventLikesModel>> getEventLiked(String docRef) async {
  //   try {
  //     List<DocumentSnapshot> snapshot = (await _ref.document(docRef).collection(AppConstants.EVENTS_LIKES_COLLECTION).getDocuments()).documents;

  //     List<EventLikesModel> eventIsLiked = snapshot
  //         .map<EventLikesModel>((doc) => EventLikesModel.fromMap(doc.data))
  //         .toList();

  //     return eventIsLiked;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
}
