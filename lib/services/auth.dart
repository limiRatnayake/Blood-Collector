import 'package:blood_collector/models/user.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  String uid;
  AuthServices({this.uid});
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Create a collection as user in cloud firestore 
  final CollectionReference _ref = Firestore.instance.collection("users");
  
//reate user object base on firebase user-frm anymous uid/customer user
  FirebaseUser _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? user : null;
  }

  //auth changes user stream
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

//signup with email and password and register
  Future signupWithEmailAndPassword(
      String email,
      String password,
      String uid,
      String name,
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
        name,
        email,
        address,
        mobileNo,
        bloodGroup,
        city,
      );
      
      //create a new document for the user with the uid
      await newRef.setData(userMod.toJson());
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error);
      return null;
    }
  }

//Sign in with email and password
  Future signinWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  //Log out
  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }


Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  
}
