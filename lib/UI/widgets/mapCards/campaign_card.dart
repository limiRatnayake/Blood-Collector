import 'package:blood_collector/UI/pages/rootPages/viewTimelineEvents/viewCampaignDetails.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapCampaignCard extends StatefulWidget {
  final String docRef;
  final String uid;
  final String imageUrl;
  final String nameOftheOrganizer;
  final String placeAddress;
  final String pickUpStartDate;

  MapCampaignCard(
      {Key key,
      this.docRef,
      this.uid,
      this.imageUrl,
      this.placeAddress,
      this.nameOftheOrganizer,
      this.pickUpStartDate})
      : super(key: key);

  @override
  _MapCampaignCardState createState() => _MapCampaignCardState();
}

class _MapCampaignCardState extends State<MapCampaignCard> {
  @override
  Widget build(BuildContext context) {
    UserService _userService = Provider.of<UserService>(context);
    AuthServices _authService = Provider.of<AuthServices>(context);

    return Container(
      alignment: Alignment.bottomLeft,
      width: MediaQuery.of(context).size.width - 12,
      child: Card(
        child: FutureBuilder(
            future: _userService.requestUserDetails(widget.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                UserModel data = UserModel.fromMap(snapshot.data.data());

                return data != null
                    ? ListTile(
                        leading: GestureDetector(
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(data.proPicUrl),
                          ),
                        ),
                        title: Text(widget.nameOftheOrganizer),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Campaign StartOn: " +
                                " " +
                                widget.pickUpStartDate),
                            Text(
                              widget.placeAddress,
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
                                                  ViewCampaignDetails(
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
                                      _launchMapUrl(widget.placeAddress);
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
