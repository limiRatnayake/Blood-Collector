import 'package:blood_collector/UI/widgets/requestHistoryPostWidget.dart';
import 'package:blood_collector/UI/widgets/request_accept_widget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AcceptRequestView extends StatefulWidget {
  @override
  _AcceptRequestViewState createState() => _AcceptRequestViewState();
}

class _AcceptRequestViewState extends State<AcceptRequestView> {
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

                                    return AcceptRequestWidget(
                                      uid: data.uid,
                                      docRef: data.docRef,
                                    );
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
}
