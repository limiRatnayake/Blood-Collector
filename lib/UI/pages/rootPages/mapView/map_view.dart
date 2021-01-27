//librarys
import 'dart:async';

//pages
import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:blood_collector/UI/widgets/mapCards/campaign_card.dart';
import 'package:blood_collector/UI/widgets/mapCards/request_card.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/event_service.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool mapToggle = false;
  double zoomVal = 1.0;
  var currentLocation;
  // GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  var events = [];

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Circle> circles;
  BitmapDescriptor customIcon;

  @override
  void initState() {
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
                        zoom: 12),
                    markers: Set<Marker>.of(markers.values),

                    myLocationEnabled: true,
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
    FirebaseFirestore.instance
        .collection("events")
        .where("category", isEqualTo: "request")
        .get()
        .then((data) {
      if (data.docs.isNotEmpty) {
        for (int i = 0; i < data.docs.length; ++i) {
          setState(() {
            events.add(data.docs[i].id);
          });

          initMarker(data.docs[i].data, data.docs[i].id);
        }
      }
    });
  }

  initMarker(events, reqEventId) {
    var hospitalLat = double.parse(events()['hospitalLat']);
    var hospitalLng = double.parse(events()['hospitalLng']);

    var markIdVals = reqEventId;
    final MarkerId markerID = MarkerId(markIdVals);
    final Marker marker = Marker(
      markerId: markerID,
      position: LatLng(hospitalLat, hospitalLng),
    );
    setState(() {
      markers[markerID] = marker;
    });
  }

  campaignFilterMarkers() {
    events = [];
    FirebaseFirestore.instance
        .collection("events")
        .where("category", isEqualTo: "campaign")
        .get()
        .then((campaignData) {
      if (campaignData.docs.isNotEmpty) {
        for (int i = 0; i < campaignData.docs.length; ++i) {
          var placeLat = double.parse(campaignData.docs[i].data()["placeLat"]);
          var placeLng = double.parse(campaignData.docs[i].data()["placeLng"]);

          Geolocator()
              .distanceBetween(currentLocation.latitude,
                  currentLocation.longitude, placeLat, placeLng)
              .then((calDist) {
            //5km distance events
            if (mounted) {
              if (calDist / 1000 < 5) {
                setState(() {
                  events.add(
                    campaignData.docs[i].id,
                  );
                });
                placeFilteredMarker(campaignData.docs[i].data,
                    campaignData.docs[i].id, calDist / 1000);
              }
            }
          });
        }
      }
    });
  }

  placeFilteredMarker(events, campEventId, distance) {
    var placeLat = double.parse(events()['placeLat']);
    var placeLng = double.parse(events()['placeLng']);

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
                      EventModel data =
                          EventModel.fromMap(snapshot.data.data());

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
    var lat = double.parse(hospitalLat);
    var long = double.parse(hospitalLong);

    return GestureDetector(
        onTap: () {
          _goToLocationOnTap(lat, long);
        },
        child: MapRequestCard(
            docRef: docRef,
            uid: uid,
            imageUrl: imageUrl,
            hospitalLat: hospitalLat,
            hospitalLng: hospitalLong,
            requestClose: requestClose,
            hospitalName: hospitalName));
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
        child: MapCampaignCard(
          docRef: docRef,
          uid: uid,
          imageUrl: imageUrl,
          nameOftheOrganizer: nameOftheOrganizer,
          placeAddress: placeAddress,
          pickUpStartDate: pickUpStartDate,
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
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          //zoomin button
          IconButton(
              icon: Icon(
                Icons.zoom_in,
                color: Color(0xff6200ee),
                size: 35,
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
                size: 35,
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
}
