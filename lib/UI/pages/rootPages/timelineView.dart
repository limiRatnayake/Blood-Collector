import 'package:blood_collector/UI/pages/rootPages/editProfileView.dart';
import 'package:blood_collector/UI/pages/rootPages/viewDetails.dart';
import 'package:blood_collector/UI/widgets/postWidget.dart';
import 'package:blood_collector/models/event_likes_model.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_likes_service.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/appConstant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatefulWidget {
  @override
  _TimelineViewState createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
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
    final AuthServices _authService = Provider.of<AuthServices>(context);
    String currentUser = _authService.user.uid;

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

                                    return PostView(
                                      currentUser: currentUser,
                                        imageUrl: data.imageUrl,
                                        uid: data.uid,
                                        docRef: data.docRef,
                                        description: data.description,
                                        createdAt: data.createdAt);
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
}
