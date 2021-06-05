//librarys
import 'dart:io';

//models & shared widgets
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/shared/appConstant.dart';

//packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventService extends ChangeNotifier {
  FirebaseFirestore _db;
  CollectionReference _ref;
  CollectionReference _insightsRef;
  CollectionReference _participantsRef;
  FirebaseStorage _storageRef = FirebaseStorage.instance;

  EventService() : _db = FirebaseFirestore.instance {
    _ref = _db.collection(AppConstants.EVENTS_COLLECTION);
    _insightsRef = _db.collection(AppConstants.INSIGHTS);
    _participantsRef =
        _db.collection(AppConstants.EVENTS_PARTICIPANTS_COLLECTION);
  }

  Future<String> addEvent(
    User user,
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
      DocumentReference newRef = _ref.doc();
      EventModel eventModel = new EventModel(
          docRef: newRef.id,
          bloodGroup: bloodGroup,
          replacementAvailability: replacementAvailability,
          unitsOfBlood: unitsOfBlood,
          unitsFilled: 0,
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

      await newRef.set(eventModel.toJson());
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
    Reference storageReference = _storageRef.ref().child(
        '${AppConstants.STORSGE_IMAGE_PATH}/${uuid}/${uuid + extention}');
    //upload the image into the firebase storage
    await storageReference.putFile(imageFile);
    //check whether it is completed
    // await uploadTask.onComplete;
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
        .orderBy("createdAt", descending: false)
        .get();
  }

  Future<QuerySnapshot> filterEvents(String area, String filter) {
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
    var getQuery = query.get();
    return getQuery;
  }

  Future<QuerySnapshot> getUserEvents(String uid) {
    return _ref.where("uid", isEqualTo: uid).get();
  }

  Future<DocumentSnapshot> requestEventsDetails(String docRef) async {
    DocumentSnapshot postSnapshot = (await _ref.doc(docRef).get());
    notifyListeners();
    return postSnapshot;
  }

  Future<DocumentSnapshot> getSavedEvents(String docRef) async {
    DocumentSnapshot postSnapshot = (await _ref.doc(docRef).get());
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
      DocumentReference newRef = _ref.doc(docRef);

      await newRef.update({
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
      DocumentReference newRef = _ref.doc(docRef);

      await newRef.update({
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
      DocumentReference newRef = _ref.doc(docRef);
      var participantRef =
          _participantsRef.where("docRef", isEqualTo: docRef).get();
      var requestSentRef = _ref.doc(docRef).collection("requested").get();

      participantRef.then(
          (QuerySnapshot snapshot) => snapshot.docs.forEach((participants) {
                _participantsRef.doc(participants.id).delete();
              }));
      requestSentRef.then(
          (QuerySnapshot snapshot) => snapshot.docs.forEach((userRequests) {
                _ref
                    .doc(docRef)
                    .collection("requested")
                    .doc(userRequests.id)
                    .delete();
              }));
      _ref
          .where("requestClose",
              isGreaterThanOrEqualTo: DateTime.now().toString())
          .get()
          .then((value) async {
        await newRef.update({"status": "Close", "totalParticipants": 0});
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
      DocumentReference newRef = _ref.doc(docRef);

      var actualParticipants = await _participantsRef
          .where("docRef", isEqualTo: docRef)
          .where("participatedStatus", isEqualTo: "Donated")
          .get();
      var avoidParticipants = await _participantsRef
          .where("docRef", isEqualTo: docRef)
          .where("participatedStatus", isEqualTo: "Not participated")
          .get();

      newRef.update({
        "actualParticipants": actualParticipants.docs.length,
        "avoidParticipants": avoidParticipants.docs.length,
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
      _ref.doc(docRef).delete();
      var likesRef = _ref.doc(docRef).collection("likes").get();

      likesRef.then((QuerySnapshot snapshot) =>
          snapshot.docs.forEach((userRequests) {
            _ref.doc(docRef).collection("likes").doc(userRequests.id).delete();
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
      Reference storageReference = _storageRef.ref(imgUrl);
      //delete the image into the firebase storage
      await storageReference.delete();
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future<void> editEventImage(String imgUrl, String docRef) async {
    try {
      //getting the refference and file name
      Reference storageReference = _storageRef.ref(imgUrl);
      //delete the image into the firebase storage
      await storageReference.delete();
      DocumentReference newRef = _ref.doc(docRef);
      await newRef
          .update({"imageUrl": "", "imageName": "", "imageExtention": ""});
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  //get insights info
  Future<QuerySnapshot> getInsights() {
    //create a composite index in firebase console
    return _insightsRef.get();
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
