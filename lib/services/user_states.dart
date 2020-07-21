
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';


// class UserStatus extends ChangeNotifier {
//   final FirebaseAuth _auth;

// FirebaseUser user;
//   UserStatus() : _auth = FirebaseAuth.instance {
//     _auth.onAuthStateChanged.listen(_onAuthStateChangeView); // get the auth changes
//   }

//   Future<void> _onAuthStateChangeView(FirebaseUser firebaseUser) async {
//     print(firebaseUser);
//     if (firebaseUser == null ) {
//       print("User is disabled");
      
//     } else {
//       print("User is enabled");
//       user = firebaseUser;
//     }
//     notifyListeners();
//   }
// }
