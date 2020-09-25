import 'package:blood_collector/UI/pages/rootPages/editCampaignView.dart';
import 'package:blood_collector/UI/pages/rootPages/editRequestView.dart';
import 'package:blood_collector/UI/widgets/donatedHistoryPostWidget.dart';
import 'package:blood_collector/UI/widgets/requestHistoryPostWidget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DonatedRequestedGetEvents extends StatefulWidget {
  final String uid;
  final String docRef;

  DonatedRequestedGetEvents({
    Key key,
    this.uid,
    this.docRef,
  }) : super(key: key);
  @override
  _DonatedRequestedGetEventsState createState() =>
      _DonatedRequestedGetEventsState();
}

class _DonatedRequestedGetEventsState extends State<DonatedRequestedGetEvents> {
  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final EventService _eventServices = Provider.of<EventService>(context);

    return FutureBuilder(
        future: _eventServices.requestEventsDetails(widget.docRef),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            EventModel data = EventModel.fromMap(snapshot.data.data);
            var getRequestCloseDate = DateTime.parse(data.requestClose);
            String requestCloseDate =
                DateFormat('yMd').format(getRequestCloseDate);
            return Center(
              child: DonatedRequestedPostView(
                imageUrl: data.imageUrl,
                uid: data.uid,
                docRef: data.docRef,
                description: data.description,
                createdAt: data.createdAt,
                category: data.category,
                approval: data.approved,
                rejectedReason: data.rejectReason,
                nameOftheOrganizer: data.nameOftheOrganizer,
                startTime: data.startTime,
                endTime: data.endTime,
                requestCloseDate: requestCloseDate,
                placeName: data.placeName,
                placeAddress: data.placeAddress,
              ),
            );
          }
        });
  }
}
