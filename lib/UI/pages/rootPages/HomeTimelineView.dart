import 'package:blood_collector/UI/pages/rootPages/editProfileView.dart';
import 'package:blood_collector/UI/pages/rootPages/viewDetails.dart';
import 'package:blood_collector/models/event_likes_model.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_likes_service.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeTimelineView extends StatefulWidget {
  @override
  _HomeTimelineViewState createState() => _HomeTimelineViewState();
}

class _HomeTimelineViewState extends State<HomeTimelineView> {
  FirebaseUser user;



  @override
  void initState() {
   
    //ask for the user loaction
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              Firestore.instance
                  .collection("users")
                  .document(currentUser.uid)
                  .get()
                  .then((DocumentSnapshot result) {
                if (result["address"] == "") {
                  Future<Null>.delayed(Duration.zero, () {
                    Scaffold.of(context).showSnackBar(
                      new SnackBar(
                        content: new Text(
                            "Please, Add your address & other details"),
                        action: SnackBarAction(
                          label: 'Go',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfileView()));
                          },
                        ),
                      ),
                    );
                  });
                }
              })
            })
        .catchError((err) => print(err));

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final EventService _eventServices = Provider.of<EventService>(context);
  
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppTopBar(title: "Home")),
      drawer: DrawerWidget(),
      body: Container(
        child: FutureBuilder(
            future: _eventServices.getEvents(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<EventModel> dataList = snapshot.data.documents
                    .map<EventModel>((doc) => EventModel.fromMap(doc.data))
                    .toList();

                return dataList.length > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: ListView.builder(
                                  itemCount: dataList.length,
                                  itemBuilder: (context, index) {
                                    EventModel data = dataList[index];

                                    return data.imageUrl != ""
                                        ? buildPostSection(
                                            data.imageUrl,
                                            data.uid,
                                            data.docRef,
                                            data.description,
                                            data.createdAt)
                                        : buildPostSectionTwo(
                                            data.uid,
                                            data.docRef,
                                            data.description,
                                            data.createdAt);
                                  })),
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            "Please check again later.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
              }
            }),
      ),
    );
  }

  Container buildPostSection(String urlPost, String uid, String docRef,
      String postDescription, String createAt) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPostFirstRow(uid, createAt),
          SizedBox(
            height: 10,
          ),
          Text(postDescription),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.width - 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(urlPost),
                )),
          ),
          // buildPostPicture(urlPost),
          SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildPostLike(context, docRef, uid),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewDetails()));
                    },
                  ),
                  Text(
                    "View",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () {},
                  ),
                  Text(
                    "Map",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildPostSectionTwo(
      String uid, String docRef, String postDescription, String createAt) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPostFirstRow(uid, createAt),
          SizedBox(
            height: 10,
          ),
          Text(postDescription),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildPostLike(context, docRef, uid),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewDetails()));
                    },
                  ),
                  Text(
                    "View",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () {},
                  ),
                  Text(
                    "Map",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Row buildPostFirstRow(String urlProfilePhoto) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           GestureDetector(
  //             onTap: () {},
  //             child: CircleAvatar(
  //               radius: 12,
  //               backgroundImage: NetworkImage(urlProfilePhoto),
  //             ),
  //           ),
  //           SizedBox(
  //             width: 5,
  //           ),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Tom Smith",
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               Text(
  //                 "Iceland",
  //                 style: TextStyle(
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.grey[500]),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //       Icon(Icons.more_vert)
  //     ],
  //   );
  // }

  Widget buildPostFirstRow(String uid, createAt) {
    final UserService _userService = Provider.of<UserService>(context);
    String date;
    // print(createAt);
    //get the event created date
    var dateTime = DateTime.parse(createAt);
    print(dateTime);
    //get the event created time
    String roughTimeString = DateFormat('jm').format(dateTime);
    print(roughTimeString);
    //get the current date
    DateTime currentTime = DateTime.now();

    if ((currentTime.year == dateTime.year) &&
        (currentTime.month == dateTime.month) &&
        (currentTime.day == dateTime.day)) {
      date = "TODAY";
      print(date);
    } else if ((currentTime.year == dateTime.year) &&
        (currentTime.month == dateTime.month)) {
      if ((currentTime.day - dateTime.day) == 1) {
        date = "YESTERDAY";
      }
    } else if (currentTime.month != dateTime.month) {
      //if it is long ago
      date = DateFormat('yMd').format(dateTime) + " " + roughTimeString;
      print(date);
    }
    print(date);
    return FutureBuilder(
        future: _userService.requestUserDetails(uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            UserModel data = UserModel.fromMap(snapshot.data.data);
            return data != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: CircleAvatar(
                              radius: 12,
                              backgroundImage: NetworkImage(data.proPicUrl),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.firstName + " " + data.lastName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "date",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500]),
                              ),
                            ],
                          )
                        ],
                      ),
                      Icon(Icons.more_vert)
                    ],
                  )
                : Text("try again later");
          }
        });
  }

  Widget buildPostLike(BuildContext context, String docRef, String uid) {
    bool isLiked;
    Map<String, dynamic> data;
    // final EventLikesService _eventLikesService = Provider.of<EventLikesService>(context);

  
    
    return Row(
              children: [
                GestureDetector(
                  onTap:(){
                  

                  },
                  child: Icon(Icons.favorite_border),),
                
              ],
            );
   
  }
}
