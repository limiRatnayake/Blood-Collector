// import 'package:blood_collector/UI/pages/rootPages/viewDetails.dart';

// import 'package:flutter/material.dart';

// import 'package:blood_collector/UI/widgets/appTopBar.dart';
// import 'package:blood_collector/UI/widgets/drawer_widget.dart';

// class EventListView extends StatefulWidget {
//   @override
//   _EventListViewState createState() => _EventListViewState();
// }

// class _EventListViewState extends State<EventListView> {
 

//   String _photoUrl = "";
//   @override
//   void initState() {
//     super.initState();
//     // new Future.delayed(const Duration(seconds: 2));
//   }

//   @override
//   Widget build(BuildContext context) {
    

//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: const Size(double.infinity, kToolbarHeight),
//           child: AppTopBar(title: "Home")),
//       drawer: DrawerWidget(),
//       body: Container(
//         // padding: EdgeInsets.only(left: 10, right: 10, top: 45),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ListView(
//                 padding: EdgeInsets.only(top: 8),
//                 children: [
//                   (_photoUrl != "")
//                       ? buildPostSection(
//                           "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=640",
//                           "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=940",
//                           "I want to be contine",
//                         )
//                       : buildPostSectionTwo(
//                           "https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=640",
//                           "I want to be contine",
//                         ),
//                   buildPostSection(
//                     "https://images.pexels.com/photos/206359/pexels-photo-206359.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=200&w=940",
//                     "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=640",
//                     "I want to be contine",
//                   ),
//                   buildPostSection(
//                     "https://images.pexels.com/photos/1212600/pexels-photo-1212600.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=200&w=1260",
//                     "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=100&w=640",
//                     "I want to be contine",
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Container buildPostSection(
//       String urlPost, String urlProfilePhoto, String postDescription) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 8),
//       padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildPostFirstRow(urlProfilePhoto),
//           SizedBox(
//             height: 10,
//           ),
//           Text(postDescription),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: MediaQuery.of(context).size.width - 60,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(22),
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: NetworkImage(urlPost),
//                 )),
//           ),
//           // buildPostPicture(urlPost),
//           SizedBox(
//             height: 5,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.favorite_border),
//                     onPressed: () {},
//                   ),
//                   Text(
//                     "Like",
//                     style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800]),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.remove_red_eye),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ViewDetails()));
//                     },
//                   ),
//                   Text(
//                     "View",
//                     style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800]),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.map),
//                     onPressed: () {},
//                   ),
//                   Text(
//                     "Map",
//                     style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800]),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildPostSectionTwo(
//       String urlProfilePhoto, String postDescription) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 8),
//       padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildPostFirstRow(urlProfilePhoto),
//           SizedBox(
//             height: 10,
//           ),
//           Text(postDescription),
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.favorite_border),
//                     onPressed: () {},
//                   ),
//                   Text(
//                     "Like",
//                     style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800]),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.remove_red_eye),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ViewDetails()));
//                     },
//                   ),
//                   Text(
//                     "View",
//                     style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800]),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.map),
//                     onPressed: () {},
//                   ),
//                   Text(
//                     "Map",
//                     style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[800]),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Row buildPostFirstRow(String urlProfilePhoto) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: () {},
//               child: Hero(
//                 tag: urlProfilePhoto,
//                 child: CircleAvatar(
//                   radius: 12,
//                   backgroundImage: NetworkImage(urlProfilePhoto),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 8,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Tom Smith",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   "Iceland",
//                   style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[500]),
//                 ),
//               ],
//             )
//           ],
//         ),
//         Icon(Icons.more_vert)
//       ],
//     );
//   }
// }
