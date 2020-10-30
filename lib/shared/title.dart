// import 'package:flutter/material.dart';
// // import 'package:alpha_wallpaper_app/core/models/image_model.dart';

// class ImageTile extends StatelessWidget {
//   // final ImageModel image;

//   // ImageTile({this.image});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigator.pushNamed(context, 'wallpaper', arguments: image);
//       },
//       child: Padding(
//         padding: EdgeInsets.all(0),
//         child: Container(
//           width: 136,
//           child: Stack(
//             overflow: Overflow.clip,
//             fit: StackFit.expand,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(right: 5, bottom: 5),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(5),
//                   ),
//                   child: FadeInImage.assetNetwork(
//                     placeholder: 'assets/img/loading.png',
//                     image: image.imageUrl,
//                     placeholderScale: 2,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
