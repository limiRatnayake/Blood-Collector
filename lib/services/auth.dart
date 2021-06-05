//models & shared widgets
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/shared/appConstant.dart';

//packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _auth;
  User _user;

  AuthServices() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChange); // get the auth changes
  }

  //Create a collection as user in cloud firestore
  //CollectionReference is used to get document, adding document etc
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection(AppConstants.USERS_COLLECTION);

  User get user => _user;

//signup with email and password and register
  Future<String> createUser(
    String email,
    String password,
    String uid,
    String firstName,
    String lastName,
    String birthDate,
    String gender,
    String mobileNo,
    String bloodGroup,
    String address,
    String userAddLat,
    String userAddLng,
    String proPicUrl,
    bool disabled,
    String userPreviouslyDonatedOrNot,
    int ifYesHowManyTimes,
    String dateOfLastDonation,
    String medicallyAdvised,
    String vaildIdentitiyCardCheck,
    String freeFromRiskBehaviour,
    String freeFromSeriousCondition,
    String travelAbroad,
    String presentMedialTreatment,
    String undergoneSurgery,
    bool lastDonationDateCheck,
  ) async {
    String message = "";
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      //DocumentReference refer to the document location in database
      DocumentReference newRef = _ref.doc(user.uid);
      await user.sendEmailVerification();
      UserModel userMod = new UserModel(
          uid: user.uid,
          userRole: "User",
          firstName: firstName,
          lastName: lastName,
          gender: gender,
          birthDate: birthDate,
          bloodGroup: bloodGroup,
          mobileNo: mobileNo,
          address: address,
          userAddLat: userAddLat,
          userAddLng: userAddLng,
          email: email,
          proPicUrl: proPicUrl,
          disabled: false,
          notificationCount: 0,
          userPreviouslyDonatedOrNot: userPreviouslyDonatedOrNot,
          ifYesHowManyTimes: ifYesHowManyTimes,
          dateOfLastDonation: dateOfLastDonation,
          medicallyAdvised: medicallyAdvised,
          vaildIdentitiyCardCheck: vaildIdentitiyCardCheck,
          freeFromRiskBehaviour: freeFromRiskBehaviour,
          freeFromSeriousCondition: freeFromSeriousCondition,
          travelAbroad: travelAbroad,
          presentMedialTreatment: presentMedialTreatment,
          undergoneSurgery: undergoneSurgery,
          lastDonationDateCheck: lastDonationDateCheck);

      //create a new document for the user with the uid
      await newRef.set(userMod.toJson());
      message = "Success";
      // return user;
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }

//Sign in with email and password
  Future<String> signIn(String email, String password) async {
    String message = "";
    try {
      User _user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (_user.emailVerified) {
        message = "Success";
      } else {
        message = "Please Verify Your Email";
      }
    } on FirebaseAuthException catch (error) {
      if (error != null && error.message != null) {
        message = error.message;
      }
    }
    notifyListeners();
    return message;
  }

  //get current user
  Future<User> getCurrentFirebaseUser() async {
    User user = _auth.currentUser;
    return user;
  }

  //Log out
  Future<void> logOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      print(e);
    }
    // try {
    //   _user = null;
    //   await _auth.signOut();
    // } catch (error) {
    //   print(error.toString());
    // }
    // notifyListeners();
  }

  //Check auth chnages
  Future<void> _onAuthStateChange(User firebaseUser) async {
    if (firebaseUser == null) {
      print("No UserModel");
    } else {
      print("Has UserModel");
      _user = firebaseUser;
    }
    notifyListeners();
  }

  Future<String> resetPassword(String emailAddress) async {
    String message = "";
    try {
      await _auth.sendPasswordResetEmail(email: emailAddress);
      return message = "Success";
    } catch (error) {
      print(error);
      if (error != null && error.message != null) message = error.message;
    }
    notifyListeners();
    return message;
  }
}
