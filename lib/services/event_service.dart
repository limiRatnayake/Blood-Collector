import 'dart:io';

import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EventService extends ChangeNotifier {
  Firestore _db;
  CollectionReference _ref;
  CollectionReference _userRef;
  CollectionReference _sentRequestRef;
  CollectionReference _insightsRef;
  CollectionReference _participantsRef;
  FirebaseStorage _storageRef = FirebaseStorage.instance;

  EventService() : _db = Firestore.instance {
    _ref = _db.collection(AppConstants.EVENTS_COLLECTION);
    _userRef = _db.collection(AppConstants.USERS_COLLECTION);
    _insightsRef = _db.collection(AppConstants.INSIGHTS);
    _participantsRef =
        _db.collection(AppConstants.EVENTS_PARTICIPANTS_COLLECTION);
  }

  Future<String> addEvent(
    FirebaseUser user,
    String bloodGroup,
    String replacementAvailability,
    String unitsOfBlood,
    Timestamp requestClose,
    String hospitalName,
    String hospitalAddress,
    String hospitalLat,
    String hospitalLng,
    String userFName,
    String userLName,
    String userPhoneNumber,
    String patientName,
    bool notifyState,
    String nameOftheOrganizer,
    String pickUpStartDate,
    String pickUpEndDate,
    String startTime,
    String endTime,
    String placeName,
    String placeAddress,
    String placeLat,
    String placeLng,
    String orgernizerConatctNo,
    String description,
    String imgName,
    String imageExtention,
    String imgUrl,
    String category,
    bool visibleState,
    String districts,
    String area,
  ) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document();
      EventModel eventModel = new EventModel(
          docRef: newRef.documentID,
          bloodGroup: bloodGroup,
          replacementAvailability: replacementAvailability,
          unitsOfBlood: unitsOfBlood,
          requestClose: requestClose,
          hospitalName: hospitalName,
          hospitalAddress: hospitalAddress,
          hospitalLat: hospitalLat,
          hospitalLng: hospitalLng,
          userFName: userFName,
          userLName: userLName,
          userPhoneNumber: userPhoneNumber,
          patientName: patientName,
          notifyState: notifyState,
          nameOftheOrganizer: nameOftheOrganizer,
          pickUpStartDate: pickUpStartDate,
          pickUpEndDate: pickUpEndDate,
          startTime: startTime,
          endTime: endTime,
          placeName: placeName,
          placeAddress: placeAddress,
          placeLat: placeLat,
          placeLng: placeLng,
          orgernizerConatctNo: orgernizerConatctNo,
          description: description,
          imageName: imgName,
          imageExtention: imageExtention,
          imageUrl: imgUrl,
          category: category,
          visibleState: visibleState,
          districts: districts,
          area: area,
          likes: 0,
          savedEvents: 0,
          userAccepted: 0,
          uid: user.uid,
          approved: false,
          rejectReason: "None",
          createdAt: new DateTime.now().toString(),
          notifyCount: 0,
          totalParticipants: 0,
          actualParticipants: 0,
          avoidParticipants: 0,
          status: "Open",
          submitListStatus: "still not");

      await newRef.setData(eventModel.toJson());
      message = "Success";
      notifyListeners();
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    return message;
  }

  Future<String> uploadImage(
    String uuid,
    String extention,
    File imageFile,
  ) async {
    String imgUrl = "";
    //getting the refference and file name
    StorageReference storageReference = _storageRef.ref().child(
        '${AppConstants.STORSGE_IMAGE_PATH}/${uuid}/${uuid + extention}');
    //upload the image into the firebase storage
    StorageUploadTask uploadTask = storageReference.putFile(imageFile);
    //check whether it is completed
    await uploadTask.onComplete;
    imgUrl = await storageReference.getDownloadURL();

    notifyListeners(); //notify or update anybody that listen to state chnages
    return imgUrl;
  }

  Future<QuerySnapshot> getEvents() {
    //create a composite index in firebase console
    return _ref
        .where("approved", isEqualTo: true)
        .where("status", isEqualTo: "Open")
        .where("requestClose", isGreaterThanOrEqualTo: DateTime.now())
        .orderBy("requestClose", descending: false)
        .orderBy("createdAt", descending: true)
        .getDocuments();
  }

  Future<QuerySnapshot> filterEvents(String area, String filter) async {
    var query = _ref
        .where("approved", isEqualTo: true)
        .where("status", isEqualTo: "Open")
        .where("requestClose", isGreaterThanOrEqualTo: DateTime.now())
        .orderBy("requestClose", descending: false)
        .orderBy("createdAt", descending: true);

    if (area != '') {
      query = query.where("area", isEqualTo: area);
    }
    if (filter == "Requests") {
      query = query.where("category", isEqualTo: "request");
    }

    return await query.getDocuments();
  }

  Future<QuerySnapshot> getUserEvents(String uid) {
    return _ref.where("uid", isEqualTo: uid).getDocuments();
  }

  Future<DocumentSnapshot> requestEventsDetails(String docRef) async {
    DocumentSnapshot postSnapshot = (await _ref.document(docRef).get());
    notifyListeners();
    return postSnapshot;
  }

  Future<DocumentSnapshot> getSavedEvents(String docRef) async {
    DocumentSnapshot postSnapshot = (await _ref.document(docRef).get());
    notifyListeners();
    return postSnapshot;
  }

  Future<String> updateRequestEvents(
    String docRef,
    String bloodGroup,
    String replacementAvailability,
    String unitsOfBlood,
    String requestClose,
    String hospitalName,
    String hospitalAddress,
    String hospitalLat,
    String hospitalLng,
    String userFName,
    String userLName,
    String userPhoneNumber,
    String description,
    String imageName,
    String imageExtention,
    String imageUrl,
  ) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document(docRef);

      await newRef.updateData({
        "bloodGroup": bloodGroup,
        "replacementAvailability": replacementAvailability,
        "unitsOfBlood": unitsOfBlood,
        "requestClose": requestClose,
        "hospitalName": hospitalName,
        "hospitalAddress": hospitalAddress,
        "hospitalLat": hospitalLat,
        "hospitalLng": hospitalLng,
        "userFName": userFName,
        "userLName": userLName,
        "userPhoneNumber": userPhoneNumber,
        "description": description,
        "imageName": imageName,
        "imageExtention": imageExtention,
        "imageUrl": imageUrl,
      });
      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

  Future<String> updateCampaignEvents(
    String docRef,
    String description,
    String imageName,
    String imageExtention,
    String imageUrl,
    String nameOfTheOrOrganizer,
    String organizerPhoneNumber,
    String organizePlaceName,
    String organizePlaceAddress,
    String placeLat,
    String placeLng,
    String pickUpStartDate,
    String pickUpEndDate,
    String startTime,
    String endTime,
    Timestamp requestClose,
  ) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document(docRef);

      await newRef.updateData({
        "description": description,
        "imageName": imageName,
        "imageExtention": imageExtention,
        "imageUrl": imageUrl,
        "nameOftheOrganizer": nameOfTheOrOrganizer,
        "orgernizerConatctNo": organizerPhoneNumber,
        "placeName": organizePlaceName,
        "placeAddress": organizePlaceAddress,
        "placeLat": placeLat,
        "placeLng": placeLng,
        "pickUpStartDate": pickUpStartDate,
        "pickUpEndDate": pickUpEndDate,
        "startTime": startTime,
        "endTime": endTime,
        "requestClose": requestClose,
      });
      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

  Future<String> updateEventCloseStatus(String docRef) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document(docRef);
      var participantRef =
          _participantsRef.where("docRef", isEqualTo: docRef).getDocuments();
      var requestSentRef =
          _ref.document(docRef).collection("requested").getDocuments();

      participantRef.then((QuerySnapshot snapshot) =>
          snapshot.documents.forEach((participants) {
            _participantsRef.document(participants.documentID).delete();
          }));
      requestSentRef.then((QuerySnapshot snapshot) =>
          snapshot.documents.forEach((userRequests) {
            _ref
                .document(docRef)
                .collection("requested")
                .document(userRequests.documentID)
                .delete();
          }));
      _ref
          .where("requestClose",
              isGreaterThanOrEqualTo: DateTime.now().toString())
          .getDocuments()
          .then((value) async {
        await newRef.updateData({
          "status": "Close",
        });
      });

      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

  Future<String> addSubmitState(
    String docRef,
  ) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document(docRef);

      var actualParticipants = await _participantsRef
          .where("docRef", isEqualTo: docRef)
          .where("participatedStatus", isEqualTo: "Donated")
          .getDocuments();
      var avoidParticipants = await _participantsRef
          .where("docRef", isEqualTo: docRef)
          .where("participatedStatus", isEqualTo: "Not participated")
          .getDocuments();

      newRef.updateData({
        "actualParticipants": actualParticipants.documents.length,
        "avoidParticipants": avoidParticipants.documents.length,
        "submitListStatus": "submitted"
      });

      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

//delete an event

  Future<String> deleteEvent(String docRef) async {
    String message = "";
    try {
      _ref.document(docRef).delete();
      var likesRef = _ref.document(docRef).collection("likes").getDocuments();

      likesRef.then((QuerySnapshot snapshot) =>
          snapshot.documents.forEach((userRequests) {
            _ref
                .document(docRef)
                .collection("likes")
                .document(userRequests.documentID)
                .delete();
          }));

      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

  Future<void> deleteEventImage(String imgUrl) async {
    try {
      //getting the refference and file name
      StorageReference storageReference =
          await _storageRef.getReferenceFromUrl(imgUrl);
      //delete the image into the firebase storage
      await storageReference.delete();
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  //get insights info
  Future<QuerySnapshot> getInsights() {
    //create a composite index in firebase console
    return _insightsRef.getDocuments();
  }

  // Future<void> setPostLikes(String docRef, String uid, bool isLiked) async {
  //   try {
  //     DocumentReference newRef =
  //         _ref.document(docRef).collection('Likes').document(uid);
  //     EventLikesModel likesModel = new EventLikesModel(docRef: isLiked);
  //     await newRef.setData(likesModel.toJson());
  //   } catch (error) {
  //     print(error);
  //   }
  //   notifyListeners();
  // }

  // Future<List<EventLikesModel>> getEventLiked() async {
  //   try {
  //     List<DocumentSnapshot> snapshot = (await _ref.getDocuments()).documents;

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
