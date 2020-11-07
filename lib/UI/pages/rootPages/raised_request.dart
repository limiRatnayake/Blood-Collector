import 'package:blood_collector/UI/widgets/raisedRequestHistoryWidget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RaisedRequestView extends StatefulWidget {
  @override
  _RaisedRequestViewState createState() => _RaisedRequestViewState();
}

class _RaisedRequestViewState extends State<RaisedRequestView> {
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

                                    return RaisedRequestedPostView(
                                        imageUrl: data.imageUrl,
                                        uid: data.uid,
                                        docRef: data.docRef,
                                        description: data.description,
                                        createdAt: data.createdAt,
                                        category: data.category,
                                        approval: data.approved,
                                        rejectedReason: data.rejectReason,
                                        status: data.status,
                                        requestClose: data.requestClose);
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
