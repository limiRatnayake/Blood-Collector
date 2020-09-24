import 'package:blood_collector/UI/pages/rootPages/editCampaignView.dart';
import 'package:blood_collector/UI/pages/rootPages/editRequestView.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DonatedRequestedPostView extends StatefulWidget {
  final String imageUrl;
  final String uid;
  final String docRef;
  final String description;
  final String createdAt;
  final String category;
  final bool approval;
  final String rejectedReason;
  final String nameOftheOrganizer;
  final String startTime;
  final String endTime;
  final String requestCloseDate;
  final String placeName;
  final String placeAddress;

  DonatedRequestedPostView(
      {Key key,
      this.imageUrl,
      this.uid,
      this.docRef,
      this.createdAt,
      this.description,
      this.category,
      this.approval,
      this.rejectedReason,
      this.nameOftheOrganizer,
      this.startTime,
      this.endTime,
      this.requestCloseDate,
      this.placeName,
      this.placeAddress})
      : super(key: key);
  @override
  _DonatedRequestedPostViewState createState() =>
      _DonatedRequestedPostViewState();
}

class _DonatedRequestedPostViewState extends State<DonatedRequestedPostView> {
  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);
    final EventService _eventServices = Provider.of<EventService>(context);
    String date;

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
    }

    return Container(
        child: Card(
      clipBehavior: Clip.antiAlias,
     
      child: Column(
        children: [
         
          widget.imageUrl != ""
              ? Container(
                  height: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(22),
                      image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(widget.imageUrl),
                  )),
                )
              : Container(),
          FutureBuilder(
              future: _userService.requestUserDetails(widget.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  UserModel data = UserModel.fromMap(snapshot.data.data);

                  return data != null
                      ? ExpansionTile(
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
                          children: [
                            ListTile(
                              leading: Icon(Icons.opacity),
                              title: Text("Organizered By"),
                              subtitle: Text(
                                widget.nameOftheOrganizer,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.access_time),
                              title: Text("Time"),
                              subtitle:
                                  Text(widget.startTime + " " + widget.endTime),
                            ),
                            ListTile(
                                leading: Icon(Icons.event_available),
                                title: Text("When they need blood"),
                                subtitle: Text(widget.requestCloseDate)),
                            ListTile(
                              leading: Icon(Icons.local_hospital),
                              title: Text("Place Name"),
                              subtitle: Text(widget.placeName),
                            ),
                            ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text("Place Address"),
                              subtitle: Text(widget.placeAddress),
                            ),
                            ListTile(
                              leading: Icon(Icons.opacity),
                              title: Text("Description"),
                              subtitle: Text(
                                widget.description,
                              ),
                            ),
                          ],
                        )
                      : Text("try again later");
                }
              }),

          // ButtonBar(
          //   alignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Row(
          //       children: [
          //         IconButton(
          //           icon: Icon(Icons.explore),
          //           onPressed: () {},
          //         ),
          //         Text(
          //           "Explore More",
          //           style: TextStyle(
          //               fontSize: 15,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.grey[800]),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    ));
  }
}
