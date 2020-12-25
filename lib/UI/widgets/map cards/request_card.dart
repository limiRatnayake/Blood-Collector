import 'package:blood_collector/UI/pages/rootPages/viewRequestDetails.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapRequestCard extends StatefulWidget {
  final String docRef;
  final String uid;
  final String imageUrl;
  final String hospitalLat;
  final String hospitalLng;
  final Timestamp requestClose;
  final String hospitalName;
  MapRequestCard({
    Key key,
    this.docRef,
    this.uid,
    this.imageUrl,
    this.hospitalLat,
    this.hospitalLng,
    this.hospitalName,
    this.requestClose,
  }) : super(key: key);

  @override
  _MapRequestCardState createState() => _MapRequestCardState();
}

class _MapRequestCardState extends State<MapRequestCard> {
  @override
  Widget build(BuildContext context) {
    UserService _userService = Provider.of<UserService>(context);
    AuthServices _authService = Provider.of<AuthServices>(context);

    DateTime createdOn = widget.requestClose.toDate();
    var requestCloseFormat = DateFormat.yMMMEd().format(createdOn);

    return Container(
      alignment: Alignment.bottomLeft,
      width: MediaQuery.of(context).size.width * 0.75,
      child: Card(
        child: FutureBuilder(
            future: _userService.requestUserDetails(widget.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                UserModel data = UserModel.fromMap(snapshot.data.data);

                return data != null
                    ? ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(data.proPicUrl),
                        ),
                        title: Text(data.firstName + " " + data.lastName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Close on: " +
                                " " +
                                requestCloseFormat.toString()),
                            Text(
                              widget.hospitalName,
                              style: TextStyle(fontSize: 11),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FlatButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewRequestDetails(
                                                      docRef: widget.docRef,
                                                      uid: widget.uid,
                                                      image: widget.imageUrl,
                                                      currentUser: _authService
                                                          .user.uid)));
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.grey[600],
                                    ),
                                    label: Text(
                                      "View",
                                      style: TextStyle(fontSize: 12),
                                    )),
                                FlatButton.icon(
                                    onPressed: () {
                                      _launchMapUrl(widget.hospitalName);
                                    },
                                    icon: Icon(
                                      Icons.near_me,
                                      color: Colors.grey[600],
                                    ),
                                    label: Text(
                                      "Navigate",
                                      style: TextStyle(fontSize: 12),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        trailing: widget.imageUrl != ""
                            ? Image.network(
                                widget.imageUrl,
                                fit: BoxFit.fitHeight,
                              )
                            : null)
                    : Text("try again later");
              }
            }),
      ),
    );
  }

  void _launchMapUrl(String placeAddress) async {
    final mapUrl =
        'https://www.google.com/maps/search/?api=1&query=$placeAddress';
    if (await canLaunch(mapUrl)) {
      await launch(mapUrl);
    } else {
      throw 'Could not launch $mapUrl';
    }
  }
}
