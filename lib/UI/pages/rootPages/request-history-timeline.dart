import 'package:blood_collector/UI/pages/rootPages/EditCampaignView.dart';
import 'package:blood_collector/UI/pages/rootPages/editRequestView.dart';
import 'package:blood_collector/UI/pages/rootPages/viewDetails.dart';
import 'package:blood_collector/UI/widgets/bottom_navigator.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ReqHistoryTimelineView extends StatefulWidget {
  @override
  _ReqHistoryTimelineViewState createState() => _ReqHistoryTimelineViewState();
}

class _ReqHistoryTimelineViewState extends State<ReqHistoryTimelineView> {
  @override
  Widget build(BuildContext context) {
    final AuthServices _authServices = Provider.of<AuthServices>(context);
    final EventService _eventServices = Provider.of<EventService>(context);
    return Scaffold(
      body: Container(
        // padding: EdgeInsets.only(left: 10, right: 10, top: 45),
        child: FutureBuilder(
            future: _eventServices.getUserEvents(_authServices.user.uid),
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
                                    var date1 = DateTime.parse(data.createdAt);
                                    String formattedTime =
                                        DateFormat.Hm().format(date1);
                                    return data.imageUrl != ""
                                        ? buildPostSection(
                                            data.imageUrl,
                                            data.description,
                                            data.approved == true
                                                ? "Approved"
                                                : "Approving...",
                                            formattedTime,
                                            data.docRef,
                                            data.category)
                                        : buildPostSectionTwo(
                                            data.description,
                                            data.approved == true
                                                ? "Approved"
                                                : "Approving...",
                                            formattedTime,
                                            data.docRef,
                                            data.category);
                                  }))
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

  Container buildPostSection(String urlPost, String postDescription,
      String approval, String createdAt, String id, String category) {
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
          buildPostFirstRow(approval, createdAt, id, category),
          SizedBox(
            height: 10,
          ),
          Text(postDescription),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  Text(
                    "Like",
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

  Container buildPostSectionTwo(String postDescription, String approval,
      String createdAt, String id, String category) {
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
          buildPostFirstRow(approval, createdAt, id, category),
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  Text(
                    "Like",
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

  Widget buildPostFirstRow(
      String approval, String createdAt, String id, String category) {
    final AuthServices _authServices = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);
    final EventService _eventServices = Provider.of<EventService>(context);

    return FutureBuilder(
        future: _userService.requestUserDetails(_authServices.user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            UserModel data = UserModel.fromMap(snapshot.data.data);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
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
                          createdAt,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Text(
                  approval,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                // _popmenuButton(id, category)
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 1:
                        if (category != "campaign") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditRequestView(
                                        docRef: id,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditCampaignView(
                                        docRef: id,
                                      )));
                        }

                        break;
                      case 2:
                        {
                          Alert(
                              context: context,
                              type: AlertType.success,
                              title:
                                  "Are you sure you want to delete this event?",
                              style: AlertStyle(
                                  isCloseButton: false,
                                  isOverlayTapDismiss: false,
                                  backgroundColor: Colors.black,
                                  alertBorder: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: Colors.white)),
                                  titleStyle:
                                      TextStyle(color: Colors.blueAccent)),
                              buttons: [
                                DialogButton(
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                DialogButton(
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      String response =
                                          await _eventServices.deleteEvent(id);
                                      if (response == "Success") {
                                        var snackBar = SnackBar(
                                          content: Text(
                                              'Your event is Successfully deleted',
                                              style: TextStyle(
                                                  color: Colors.blueGrey)),
                                        );
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                             Navigator.of(context).pop();
                                      }
                                    })
                              ]).show();
                          // showDialog(
                          //     context: context,
                          //     barrierDismissible: false,
                          //     builder: (BuildContext context) {
                          //       return new AlertDialog(
                          //         title: new Text('You clicked on'),
                          //         content: new SingleChildScrollView(
                          //           child: new ListBody(
                          //             children: [
                          //               new Text(
                          //                   'This is a Dialog Box. Click OK to Close.'),
                          //             ],
                          //           ),
                          //         ),
                          //         actions: [
                          //           new FlatButton(
                          //             child: new Text('Ok'),
                          //             onPressed: () {
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //         ],
                          //       );
                          //     });
                        }
                        break;
                    }
                  },
                )
              ],
            );
          }
        });
  }

  Widget _popmenuButton(String id, String category) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: Text(
              "Edit",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(
              "Delete",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 1:
              if (category != "campaign") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditRequestView(
                              docRef: id,
                            )));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditCampaignView(
                              docRef: id,
                            )));
              }

              break;
            case 2:
              {
                Alert(
                    context: context,
                    type: AlertType.success,
                    title: "Are you sure you want to delete this event?",
                    style: AlertStyle(
                        isCloseButton: false,
                        isOverlayTapDismiss: false,
                        backgroundColor: Colors.black,
                        alertBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.white)),
                        titleStyle: TextStyle(color: Colors.blueAccent)),
                    buttons: [
                      DialogButton(
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      DialogButton(
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {})
                    ]).show();
                // showDialog(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (BuildContext context) {
                //       return new AlertDialog(
                //         title: new Text('You clicked on'),
                //         content: new SingleChildScrollView(
                //           child: new ListBody(
                //             children: [
                //               new Text(
                //                   'This is a Dialog Box. Click OK to Close.'),
                //             ],
                //           ),
                //         ),
                //         actions: [
                //           new FlatButton(
                //             child: new Text('Ok'),
                //             onPressed: () {
                //               Navigator.of(context).pop();
                //             },
                //           ),
                //         ],
                //       );
                //     });
              }
              break;
          }
        },
      );
}
