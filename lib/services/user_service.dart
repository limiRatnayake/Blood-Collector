import 'dart:io';

import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  Firestore _db;
  CollectionReference _ref;
  UserModel _userDetails;

  UserService() : _db = Firestore.instance {
    _ref = _db.collection(AppConstants.USERS_COLLECTION);
  }

  UserModel get userDetails => _userDetails;

  Future<DocumentSnapshot> requestUserDetails(String uid) async {
    DocumentSnapshot postSnapshot = (await _ref.document(uid).get());
    notifyListeners();
    return postSnapshot;
  }

  // Future<QuerySnapshot> getUsersData(uid) {
  //   return _ref.where("uid", isEqualTo: uid).getDocuments();
  // }

  Future<String> updateUserProfile(
    String uid,
    String firstName,
    String lastName,
    String address,
    String gender,
    String birthDate,
    String bloodGroup,
    String mobileNo,
    String proPicUrl,
  ) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document(uid);

      await newRef.updateData({
        "firstName": firstName,
        "lastName": lastName,
        "address": address,
        "gender": gender,
        "birthDate": birthDate,
        "bloodGroup": bloodGroup,
        "mobileNo": mobileNo,
        "proPicUrl": proPicUrl,
      });
      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

  Future<String> uploadImage(
    String uuid,
    String extention,
    File imageFile,
  ) async {
    String proPicUrl = "";
    //getting the refference and file name
    StorageReference storageReference = _storageRef.ref().child(
        '${AppConstants.STORSGE_PROFILE_PIC_PATH}/${uuid}/${uuid + extention}');
    //upload the image into the firebase storage
    StorageUploadTask uploadTask = storageReference.putFile(imageFile);
    //check whether it is completed
    await uploadTask.onComplete;
    proPicUrl = await storageReference.getDownloadURL();

    notifyListeners();
    return proPicUrl;
  }

  Future<String> deleteImage(String imgUrl, String proPicUrl) async {
    String message = "";

    try {
      var firebaseUser = await _auth.currentUser();
      //getting the refference and file name
      StorageReference storageReference =
          await _storageRef.getReferenceFromUrl(imgUrl);
      //delete the image into the firebase storage
      await storageReference.delete();

      DocumentReference newRef = _ref.document(firebaseUser.uid);

      await newRef.updateData({
        "proPicUrl": proPicUrl,
      });
      message = "Deleted";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }

    notifyListeners();
    return message;
  }

  Future<bool> vaildatePassword(String password) async {
    var firebaseUser = await _auth.currentUser();

    var authCredentials = EmailAuthProvider.getCredential(
        email: firebaseUser.email, password: password);
    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> updateDonorSelectionCriteria(
      String uid,
      String userPreviouslyDonatedOrNot,
      String ifYesHowManyTimes,
      String dateOfLastDonation,
      String medicallyAdvised,
      String vaildIdentitiyCardCheck,
      String freeFromRiskBehaviour,
      String freeFromSeriousCondition,
      String travelAbroad,
      String presentMedialTreatment,
      String undergoneSurgery,
      bool availability,
      bool lastDonationDateCheck) async {
    String message = "";
    try {
      DocumentReference newRef = _ref.document(uid);

      await newRef.updateData({
        "userPreviouslyDonatedOrNot": userPreviouslyDonatedOrNot,
        "ifYesHowManyTimes": ifYesHowManyTimes,
        "dateOfLastDonation": dateOfLastDonation,
        "medicallyAdvised": medicallyAdvised,
        "vaildIdentitiyCardCheck": vaildIdentitiyCardCheck,
        "freeFromRiskBehaviour": freeFromRiskBehaviour,
        "freeFromSeriousCondition": freeFromSeriousCondition,
        "travelAbroad": travelAbroad,
        "presentMedialTreatment": presentMedialTreatment,
        "undergoneSurgery": undergoneSurgery,
        "availability": availability,
        "lastDonationDateCheck": lastDonationDateCheck
      });
      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

  Future<String> updateEmail(String email) async {
    String message = "";
    try {
      var firebaseUser = await _auth.currentUser();
      firebaseUser
          .updateEmail(email)
          .then((value) => firebaseUser.sendEmailVerification())
          .catchError((e) {
        print(e);
      });

      DocumentReference newRef = _ref.document(firebaseUser.uid);

      await newRef.updateData({
        "email": email,
      });

      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

  Future<String> updatePassword(String password) async {
    String message = "";
    try {
      var firebaseUser = await _auth.currentUser();
      firebaseUser.updatePassword(password);

      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

  Future<String> updateUserAddress(
      String address, String latitude, String longitude) async {
    String message = "";
    try {
      var firebaseUser = await _auth.currentUser();

      DocumentReference newRef = _ref.document(firebaseUser.uid);

      await newRef.updateData({
        "address": address,
        "userAddLat": latitude,
        "userAddLng": longitude
      });
      message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }
}
