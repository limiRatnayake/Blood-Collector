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
  FirebaseStorage _storageRef = FirebaseStorage.instance;

  EventService() : _db = Firestore.instance {
    _ref = _db.collection(AppConstants.EVENTS_COLLECTION);
  }

  Future<String> addEvent(
      FirebaseUser user,
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
      bool notifyState,
      String nameOftheOrganizer,
      String pickUpDate,
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
      String category) async {
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
        notifyState: notifyState,
        nameOftheOrganizer: nameOftheOrganizer,
        pickUpDate: pickUpDate,
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
        uid: user.uid,
        approved: false,
        rejectReason: "None",
        createdAt: new DateTime.now().toString(),
      );

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

    notifyListeners();
    return imgUrl;
  }

// Future<List<String>> getData() async{
// var values = new List<String>();
// values.add("");
// values.add("");
// values.add("");
//   return values;
// }

  Future<QuerySnapshot> getEvents() async {
    // var query = _ref.where("approved" == "true");
    return _ref.getDocuments();
  }

  Future<QuerySnapshot> getUserEvents(String uid) {
    return _ref.where("uid", isEqualTo: uid).getDocuments();
  }
}
