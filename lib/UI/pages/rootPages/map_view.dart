import 'dart:async';

import 'package:blood_collector/UI/pages/rootPages/viewCampaignDetails.dart';
import 'package:blood_collector/UI/pages/rootPages/viewRequestDetails.dart';
import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  AuthServices _authService;
  UserService _userService;

  bool mapToggle = false;
  double zoomVal = 1.0;
  var currentLocation;
  // GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  var events = [];
  // List<Marker> _markers = <Marker>[];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor customIcon;
  // void _onMapCreated(controller) {
  //   setState(() {
  //     mapController = controller;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//lock the portrait mode otherwise it is hard to scroll through the map
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    //get the current user location
    Geolocator().getCurrentPosition().then((value) {
      if (mounted) {
        setState(() {
          currentLocation = value;
          mapToggle = true;
          populateRequestEvents();
          campaignFilterMarkers();
        });
      }
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(0, 5)), 'assets/location-pin.png')
        .then((d) {
      customIcon = d;
    });
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthServices>(context);
    _userService = Provider.of<UserService>(context);

    return Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.3),
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppTopBar(title: "Map View")),
        drawer: DrawerWidget(),
        body: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height - 80.0,
            width: double.infinity,
            child: mapToggle
                ? GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    //set the initial camera position to users location
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation.latitude,
                            currentLocation.longitude),
                        zoom: 17),
                    markers: Set<Marker>.of(markers.values),
                    myLocationEnabled: false,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                  )
                : Center(child: Text("Loading..")),
          ),
          _zoomFunction(),
          //only shows the events that happens near 5km
          _buildConatiner(context)
        ]));
  }

  void populateRequestEvents() {
    events = [];
    Firestore.instance
        .collection("events")
        .where("category", isEqualTo: "request")
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          setState(() {
            events.add(docs.documents[i].documentID);
          });

          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  initMarker(events, reqEventId) {
    var hospitalLat = double.parse(events['hospitalLat']);
    var hospitalLng = double.parse(events['hospitalLng']);

    var markIdVal = reqEventId;
    final MarkerId markerID = MarkerId(markIdVal);
    final Marker marker =
        Marker(markerId: markerID, position: LatLng(hospitalLat, hospitalLng));
    setState(() {
      markers[markerID] = marker;
    });
  }

  campaignFilterMarkers() {
    events = [];
    Firestore.instance
        .collection("events")
        .where("category", isEqualTo: "campaign")
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          var placeLat = double.parse(docs.documents[i].data["placeLat"]);
          var placeLng = double.parse(docs.documents[i].data["placeLng"]);

          Geolocator()
              .distanceBetween(currentLocation.latitude,
                  currentLocation.longitude, placeLat, placeLng)
              .then((calDist) {
            //5km distance events
            if (mounted) {
              if (calDist / 1000 < 5) {
                setState(() {
                  events.add(
                    docs.documents[i].documentID,
                  );
                });
                placeFilteredMarker(docs.documents[i].data,
                    docs.documents[i].documentID, calDist / 1000);
              }
            }
          });
        }
      }
    });
  }

  placeFilteredMarker(events, campEventId, distance) {
    var placeLat = double.parse(events['placeLat']);
    var placeLng = double.parse(events['placeLng']);

    var markIdVal = campEventId;

    final MarkerId markerID = MarkerId(markIdVal);

    final Marker marker = Marker(
        markerId: markerID,
        position: LatLng(placeLat, placeLng),
        icon: customIcon);
    setState(() {
      markers[markerID] = marker;
    });
  }

  //get cards
  // campaigns according to the 5km radius
  // and all the blood requests
  Widget _buildConatiner(BuildContext context) {
    final EventService _eventServices = Provider.of<EventService>(context);

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: 120,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return FutureBuilder(
                  future: _eventServices
                      .requestEventsDetails(events[index].toString()),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      EventModel data = EventModel.fromMap(snapshot.data.data);

                      return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: data.category != "campaign"
                              ? _requestBoxes(
                                  data.docRef,
                                  data.uid,
                                  data.imageUrl,
                                  data.hospitalLat,
                                  data.hospitalLng,
                                  data.userFName,
                                  data.userLName,
                                  data.requestClose,
                                  data.hospitalName)
                              : _campaignBoxes(
                                  data.docRef,
                                  data.uid,
                                  data.imageUrl,
                                  data.placeLat,
                                  data.placeLng,
                                  data.nameOftheOrganizer,
                                  data.placeAddress,
                                  data.startTime,
                                  data.endTime,
                                  data.pickUpStartDate,
                                  data.pickUpEndDate));
                    }
                  });
            }),
      ),
    );
  }

  Widget _requestBoxes(
      String docRef,
      String uid,
      String imageUrl,
      String hospitalLat,
      String hospitalLong,
      String userFName,
      String userLName,
      Timestamp requestClose,
      String hospitalName) {
    _userService = Provider.of<UserService>(context);
    var lat = double.parse(hospitalLat);
    var long = double.parse(hospitalLong);
    DateTime createdOn = requestClose.toDate();
    var requestCloseFormat = DateFormat.yMMMEd().format(createdOn);
    // var createdOnFormat =
    //     DateFormat.yMMMEd().add_jm().format(createdOn);
    return GestureDetector(
        onTap: () {
          _goToLocationOnTap(lat, long);
        },
        child: Container(
          alignment: Alignment.bottomLeft,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Card(
            child: FutureBuilder(
                future: _userService.requestUserDetails(uid),
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
                                  hospitalName,
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
                                                          docRef: docRef,
                                                          uid: uid,
                                                          image: imageUrl,
                                                          currentUser:
                                                              _authService
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
                                          _launchMapUrl(hospitalName);
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
                            trailing: imageUrl != ""
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.fitHeight,
                                  )
                                : null)
                        : Text("try again later");
                  }
                }),
          ),
        ));
  }

  Widget _campaignBoxes(
      String docRef,
      String uid,
      String imageUrl,
      String placeLat,
      String placeLng,
      String nameOftheOrganizer,
      String placeAddress,
      String startTime,
      String endTime,
      String pickUpStartDate,
      String pickUpEndDate) {
    var lat = double.parse(placeLat);
    var long = double.parse(placeLng);
    return GestureDetector(
        onTap: () {
          _goToLocationOnTap(lat, long);
        },
        child: Container(
          alignment: Alignment.bottomLeft,
          width: MediaQuery.of(context).size.width - 60,
          child: Card(
            child: FutureBuilder(
                future: _userService.requestUserDetails(uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    UserModel data = UserModel.fromMap(snapshot.data.data);

                    return data != null
                        ? ListTile(
                            leading: GestureDetector(
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(data.proPicUrl),
                              ),
                            ),
                            title: Text(nameOftheOrganizer),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Campaign StartOn: " +
                                    " " +
                                    pickUpStartDate),
                                Text(
                                  placeAddress,
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
                                                          docRef: docRef,
                                                          uid: uid,
                                                          image: imageUrl,
                                                          currentUser:
                                                              _authService
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
                                          _launchMapUrl(placeAddress);
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
                            trailing: imageUrl != ""
                                ? Image.network(
                                    imageUrl,
                                    fit: BoxFit.fitHeight,
                                  )
                                : null)
                        : Text("try again later");
                  }
                }),
          ),
        ));
  }

  Future<void> _goToLocationOnTap(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }

  Widget _zoomFunction() {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        children: [
          //zoomin button
          IconButton(
              icon: Icon(
                Icons.zoom_in,
                color: Color(0xff6200ee),
                size: 30,
              ),
              onPressed: () {
                _zoomIn(zoomVal);
                zoomVal++;
              }),
          //zoomout button
          IconButton(
              icon: Icon(
                Icons.zoom_out,
                color: Color(0xff6200ee),
                size: 30,
              ),
              onPressed: () {
                _zoomOut(zoomVal);
                zoomVal--;
              }),
        ],
      ),
    );
  }

  Future<void> _zoomOut(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: zoomVal)));
  }

  Future<void> _zoomIn(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: zoomVal)));
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
