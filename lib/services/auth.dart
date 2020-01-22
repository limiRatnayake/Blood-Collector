import 'package:blood_collector/Module/userFirebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//create user object base on firebase user-frm anymous uid/customer user
  UserFirebase _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? UserFirebase(uid: user.uid) : null;
  }

  //auth changes user stream
  Stream<UserFirebase> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

//signup with email and password
  Future signupWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      //create a new document for the user with the uid
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
  Future logOut() async{
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
