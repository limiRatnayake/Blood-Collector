//pages
import 'package:blood_collector/UI/widgets/donatedHistoryCards/donatedCampaignHistoryWidget.dart';
import 'package:blood_collector/UI/widgets/donatedHistoryCards/donatedRequestHistoryWidget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';

//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonatedRequestedGetEvents extends StatefulWidget {
  final String participantId;
  final String uid;
  final String docRef;
  final String currentUser;
  final String participatedStatus;

  DonatedRequestedGetEvents(
      {Key key,
      this.participantId,
      this.uid,
      this.docRef,
      this.currentUser,
      this.participatedStatus})
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
            EventModel data = EventModel.fromMap(snapshot.data.data());

            return Center(
                child: data.category != "request"
                    ? DonatedCampaignPostView(
                        participantId: widget.participantId,
                        participatedStatus: widget.participatedStatus,
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
                        requestCloseDate: data.requestClose,
                        placeName: data.placeName,
                        placeAddress: data.placeAddress,
                        currentUser: widget.currentUser,
                        submitListStatus: data.submitListStatus)
                    : DonatedRequestPostView(
                        participantId: widget.participantId,
                        participatedStatus: widget.participatedStatus,
                        imageUrl: data.imageUrl,
                        uid: data.uid,
                        docRef: data.docRef,
                        userPhoneNumber: data.userPhoneNumber,
                        description: data.description,
                        createdAt: data.createdAt,
                        category: data.category,
                        approval: data.approved,
                        bloodGroup: data.bloodGroup,
                        unitsOfBlood: data.unitsOfBlood,
                        requestCloseDate: data.requestClose,
                        hospitalName: data.hospitalName,
                        hospitalAddress: data.hospitalAddress,
                        patientName: data.patientName,
                        status: data.status,
                        currentUser: widget.currentUser,
                      ));
          }
        });
  }
}
