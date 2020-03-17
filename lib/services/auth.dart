import 'package:blood_collector/models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _auth;
  FirebaseUser _user;

  AuthServices() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChange); // get the auth changes
  }

  //Create a collection as user in cloud firestore
  final CollectionReference _ref = Firestore.instance.collection("users");

//signup with email and password and register
  Future<FirebaseUser> signupWithEmailAndPassword(
      String email,
      String password,
      String uid,
      String firstName,
      String lastName,
      String birthDate,
      String gender,
      String mobileNo,
      String bloodGroup,
      String city,
      String address) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      DocumentReference newRef = _ref.document(user.uid);
      User userMod = new User(
        user.uid,
        firstName,
        lastName,
        gender,
        birthDate,
        bloodGroup,
        mobileNo,
        city,
        address,
        email,
      );

      //create a new document for the user with the uid
      await newRef.setData(userMod.toJson());
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

//Sign in with email and password
  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      _user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      print("Sign in" + _user.displayName);
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return _user;
  }

  //get current user
  Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser user = await _auth.currentUser();
    return user;
  }

  //Log out
  Future<void> logOut() async {
    try {
      _user = null;
      await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
    notifyListeners();
  }

  //Check auth chnages
  Future<void> _onAuthStateChange(FirebaseUser firebaseUser) async {
    print(firebaseUser);
    if (firebaseUser == null) {
      print("No User");
    } else {
      print("Has User");
      _user = firebaseUser;
    }
    notifyListeners();
  }
}
