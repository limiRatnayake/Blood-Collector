import 'dart:async';
import 'dart:collection';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool mapToggle = false;
  var currentLocation;
  // GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  // List<Marker> _markers = <Marker>[];
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // void _onMapCreated(controller) {
  //   setState(() {
  //     mapController = controller;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //get the current user location
    Geolocator().getCurrentPosition().then((value) {
      setState(() {
        currentLocation = value;
        mapToggle = true;
        populateRequestEvents();
        filterMarkers();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    myLocationEnabled: true,
                  )
                : Center(child: Text("Loading..")),
          ),
          _buildConatiner(context)
        ]));
  }

  void populateRequestEvents() {
    Firestore.instance
        .collection("events")
        .where("category", isEqualTo: "request")
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
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

  filterMarkers() {
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
            //3km distance events
            if (calDist / 1000 < 3) {
              placeFilteredMarker(docs.documents[i].data,
                  docs.documents[i].documentID, calDist / 1000);
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

    final Marker marker =
        Marker(markerId: markerID, position: LatLng(placeLat, placeLng));
    setState(() {
      markers[markerID] = marker;
    });
  }

  // //get cards
  Widget _buildConatiner(BuildContext context) {
    final EventService _eventServices = Provider.of<EventService>(context);

    return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 120,
          child: FutureBuilder(
              future: _eventServices.getCampaignEvents(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  // EventModel data = EventModel.fromMap(snapshot.data.data);
                  List<EventModel> dataList = snapshot.data.documents
                      .map<EventModel>((doc) => EventModel.fromMap(doc.data))
                      .toList();

                  return dataList.length > 0
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            EventModel data = dataList[index];

                            return _boxes(data.imageUrl, data.placeLat,
                                data.placeLng, data.nameOftheOrganizer);
                          })
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
        ));
  }

  Widget _boxes(String imageUrl, String lat, String long, String camapignName) {
    // var placeLat = double.parse(lat);
    // var placeLng = double.parse(long);
    return GestureDetector(
      // onTap: () {
      //   _gotoLocation(placeLat, placeLng);
      // },
      child: Container(
        child: new FittedBox(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            imageUrl != null
                ? Container(
                    width: 180,
                    margin: EdgeInsets.only(right: 20),
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image(
                            image: NetworkImage(imageUrl),
                            height: 60,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            camapignName,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          // Text(
                          //   "20 Items",
                          //   style: TextStyle(fontSize: 16, color: Colors.white),
                          // ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: 180,
                    margin: EdgeInsets.only(right: 20),
                    height: 120,
                    decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            camapignName,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Text(
                          //   "20 Items",
                          //   style: TextStyle(fontSize: 16, color: Colors.white),
                          // ),
                        ],
                      ),
                    ),
                  ),
          ],
        )),
      ),
    );
  }

  // Future<void> _gotoLocation(double lat, double long) async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //     target: LatLng(lat, long),
  //     zoom: 15,
  //     tilt: 50.0,
  //     bearing: 45.0,
  //   )));
  // }
}
