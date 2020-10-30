import 'package:blood_collector/UI/pages/rootPages/viewCampaignDetails.dart';
import 'package:blood_collector/UI/pages/rootPages/viewRequestDetails.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostView extends StatefulWidget {
  final String currentUser;
  final String imageUrl;
  final String uid;
  final String docRef;
  final String description;
  final String createdAt;
  final String category;

  PostView(
      {Key key,
      this.currentUser,
      this.imageUrl,
      this.uid,
      this.docRef,
      this.createdAt,
      this.description,
      this.category})
      : super(key: key);
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  DocumentReference likeRef;
  DocumentReference savedEventRef;
  CollectionReference eventRef;
  bool isLiked = false;
  bool isSaved = false;
  var savedEventDocs;

  Map<String, dynamic> likeData;
  Map<String, dynamic> savedEventData;

  _isLiked() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  _isSaved() {
    setState(() {
      isSaved = !isSaved;
    });
  }

  @override
  void initState() {
    likeRef = Firestore.instance
        .collection("events")
        .document(widget.docRef)
        .collection("likes")
        .document(widget.currentUser);
    savedEventRef = Firestore.instance
        .collection("users")
        .document(widget.currentUser)
        .collection("savedEvents")
        .document(widget.docRef);

    super.initState();
    likeRef.get().then((value) {
      likeData = value.data;
    });
    savedEventRef.get().then((value) {
      savedEventData = value.data;
    });
    eventRef = Firestore.instance.collection("events");
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final EventService _eventServices = Provider.of<EventService>(context);
    String date;
    // print(widget.createdAt);
    //get the event created date
    var checkedTime = DateTime.parse(widget.createdAt);

    //get the event created time
    String roughTimeString = DateFormat('jm').format(checkedTime);

    //get the current date
    DateTime currentTime = DateTime.now();
    if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month) &&
        (currentTime.day == checkedTime.day)) {
      date = "TODAY";
    } else if ((currentTime.year == checkedTime.year) &&
        (currentTime.month == checkedTime.month)) {
      if ((currentTime.day - checkedTime.day) == 1) {
        date = "YESTERDAY";
      } else {
        date = DateFormat('yMd').format(checkedTime) + " " + roughTimeString;
      }
    } else {
      date = DateFormat('yMd').format(checkedTime) + " " + roughTimeString;
    }

    return Container(
        child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          FutureBuilder(
              future: _userService.requestUserDetails(widget.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  UserModel data = UserModel.fromMap(snapshot.data.data);

                  return data != null
                      ? ListTile(
                          leading: GestureDetector(
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(data.proPicUrl),
                            ),
                          ),
                          title: Text(
                            data.firstName + " " + data.lastName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            date,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500]),
                          ),
                        )
                      : Text("try again later");
                }
              }),

          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.description,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          widget.imageUrl != ""
              ? Container(
                  height: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(widget.imageUrl),
                      )),
                )
              : Container(),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _isLiked();

                      likeRef.get().then((value) => {
                            if (value.data != null)
                              {
                                print("like ref is nt null"),
                                if (value.data.keys.contains(widget.docRef))
                                  {
                                    Firestore.instance
                                        .runTransaction((Transaction tx) async {
                                      DocumentSnapshot docSnapshot =
                                          await tx.get(
                                              eventRef.document(widget.docRef));
                                      if (docSnapshot.exists) {
                                        await tx.update(
                                            eventRef.document(widget.docRef),
                                            <String, dynamic>{
                                              'likes':
                                                  docSnapshot.data["likes"] - 1
                                            });
                                      }
                                    }),
                                  },
                                likeRef.delete(),
                                setState(() {
                                  likeRef.get().then((value) {
                                    likeData = value.data;
                                  });
                                })
                              }
                            else
                              {
                                Firestore.instance
                                    .runTransaction((Transaction tx) async {
                                  DocumentSnapshot docSnapshot = await tx
                                      .get(eventRef.document(widget.docRef));
                                  if (docSnapshot.exists) {
                                    await tx.update(
                                        eventRef.document(widget.docRef),
                                        <String, dynamic>{
                                          'likes': docSnapshot.data["likes"] + 1
                                        });
                                  }
                                }),
                                likeRef.setData({widget.docRef: true}),
                                setState(() {
                                  likeRef.get().then((value) {
                                    likeData = value.data;
                                  });
                                })
                              }
                          });
                    },
                    icon:
                        likeData != null && likeData.containsKey(widget.docRef)
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(Icons.favorite_border),
                  ),
                  FutureBuilder(
                      future:
                          _eventServices.requestEventsDetails(widget.docRef),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          EventModel data =
                              EventModel.fromMap(snapshot.data.data);
                          return data.likes != 0
                              ? Text(
                                  (data.likes).toString() + " " + 'likes',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800]),
                                )
                              : Container();
                        }
                      })
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.category != "request") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewCampaignDetails(
                                    docRef: widget.docRef,
                                    uid: widget.uid,
                                    currentUser: widget.currentUser)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewRequestDetails(
                                    docRef: widget.docRef,
                                    uid: widget.uid,
                                    currentUser: widget.currentUser)));
                      }
                    },
                    icon: Icon(Icons.remove_red_eye),
                  ),
                  Text(
                    "View",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: savedEventData != null &&
                            savedEventData.containsValue(widget.docRef)
                        ? Icon(Icons.bookmark)
                        : Icon(Icons.bookmark_border),
                    onPressed: () {
                      _isSaved();

                      savedEventRef.get().then((value) => {
                            if (value.data != null)
                              {
                                print("like ref is nt null"),
                                if (value.data.values.contains(widget.docRef))
                                  {
                                    Firestore.instance
                                        .runTransaction((Transaction tx) async {
                                      DocumentSnapshot docSnapshot =
                                          await tx.get(
                                              eventRef.document(widget.docRef));
                                      if (docSnapshot.exists) {
                                        await tx.update(
                                            eventRef.document(widget.docRef),
                                            <String, dynamic>{
                                              'savedEvents': docSnapshot
                                                      .data["savedEvents"] -
                                                  1
                                            });
                                      }
                                    }),
                                  },
                                savedEventRef.delete(),
                                setState(() {
                                  savedEventRef.get().then((value) {
                                    savedEventData = value.data;
                                  });
                                })
                              }
                            else
                              {
                                Firestore.instance
                                    .runTransaction((Transaction tx) async {
                                  DocumentSnapshot docSnapshot = await tx
                                      .get(eventRef.document(widget.docRef));
                                  if (docSnapshot.exists) {
                                    await tx.update(
                                        eventRef.document(widget.docRef),
                                        <String, dynamic>{
                                          'savedEvents':
                                              docSnapshot.data["savedEvents"] +
                                                  1
                                        });
                                  }
                                }),
                                savedEventRef
                                    .setData({"docRef": widget.docRef}),
                                setState(() {
                                  savedEventRef.get().then((value) {
                                    savedEventData = value.data;
                                  });
                                })
                              }
                          });
                    },
                  ),
                  Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                  ),
                ],
              ),
            ],
          ),
          // Image.asset()
        ],
      ),
    ));
  }
}
