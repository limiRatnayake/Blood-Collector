import 'package:blood_collector/UI/widgets/donatedCampaignHistoryWidget.dart';
import 'package:blood_collector/UI/widgets/donatedRequestHistoryWidget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DonatedRequestedGetEvents extends StatefulWidget {
  final String participantId;
  final String uid;
  final String docRef;
  final String currentUser;

  DonatedRequestedGetEvents(
      {Key key, this.participantId, this.uid, this.docRef, this.currentUser})
      : super(key: key);
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
            // var getRequestCloseDate = DateTime.parse(data.requestClose);
            // String requestCloseDate =
            //     DateFormat('yMd').format(data.requestClose);
            return Center(
                child: data.category != "request"
                    ? DonatedCampaignPostView(
                        participantId: widget.participantId,
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
                        requestCloseDate: data.requestClose.toString(),
                        placeName: data.placeName,
                        placeAddress: data.placeAddress,
                        currentUser: widget.currentUser)
                    : DonatedRequestPostView(
                        participantId: widget.participantId,
                        imageUrl: data.imageUrl,
                        uid: data.uid,
                        docRef: data.docRef,
                        description: data.description,
                        createdAt: data.createdAt,
                        category: data.category,
                        approval: data.approved,
                        bloodGroup: data.bloodGroup,
                        unitsOfBlood: data.unitsOfBlood,
                        requestCloseDate: data.requestClose.toString(),
                        hospitalName: data.hospitalName,
                        hospitalAddress: data.hospitalAddress,
                        patientName: data.patientName,
                        currentUser: widget.currentUser));
          }
        });
  }
}
