import 'dart:async';
import 'dart:collection';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:blood_collector/services/event_service.dart';
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
  GoogleMapController mapController;
  var events = [];
  // List<Marker> _markers = <Marker>[];
  Set<Marker> _markers = HashSet<Marker>();
  // Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //get the current user location
    Geolocator().getCurrentPosition().then((value) {
      setState(() {
        currentLocation = value;
        mapToggle = true;
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
                    onMapCreated: _onMapCreated,

                    //set the initial camera position to colombo
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation.latitude,
                            currentLocation.longitude),
                        zoom: 18),
                    markers: _markers,
                    myLocationEnabled: true,
                    onTap: (position) {
                      Marker mark1 =
                          Marker(markerId: MarkerId('"1"'), position: position);
                      setState(() {
                        _markers.add(mark1);
                      });
                    },
                    // myLocationButtonEnabled: true,
                  )
                : Center(child: Text("Loading..")),
          ),
        ]));
  }

  void populateClients() {
    events = [];
    final EventService _userService = Provider.of<EventService>(context);

    _userService.getEvents().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          events.add(docs.documents[i].data);
          // initMarker(docs.documents[i].data);
        }
      }
    });
  }

  // initMarker(client) {
  //   _markers.add(Marker(
  //       markerId: MarkerId('SomeId'),
  //       position: LatLng(client['hospitalLat'].latitude, client['hospitalLng']),
  //       infoWindow: InfoWindow(title: 'The title of the marker')));
  // }
}
