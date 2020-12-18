// //packages
// import 'package:flutter/material.dart';

// class PreventDoubleTap extends StatefulWidget {
//   @override
//   _PreventDoubleTapState createState() => _PreventDoubleTapState();
// }

// class _PreventDoubleTapState extends State<PreventDoubleTap> {
//   bool _isButtonTap = false;

//   _onTap() {
//     setState(() {
//       _isButtonTap = true;
//     });
//   }

//   BoxDecoration _boxDecoration() {
//     return BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.0),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6,
//               offset: Offset(3, 6)) //BoxShadow
//         ]);
//   }

//   Widget _buildCounterButton() {
//     return RaisedButton(
//       elevation: 0.0,
//       child: Text("DONATE",
//           style: TextStyle(
//             fontFamily: "Roboto",
//             fontSize: 18.0,
//           )),
//       textColor: Colors.red,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.5)),
//       onPressed: _buttonPressed(),
//     );
//   }

//   Function _buttonPressed() {
//     if (_isButtonTap) {
//       return null;
//     } else {
//       return () {
//         _onTap();
//       };
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 58.0,
//       margin: EdgeInsets.symmetric(horizontal: 15.0),
//       decoration: _boxDecoration(),
//       child: ButtonTheme(child: _buildCounterButton()),
//     );
//   }
// }
