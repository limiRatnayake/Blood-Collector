import 'dart:async';
import 'dart:collection';

import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Set<Marker> _markers = HashSet<Marker>();
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    // setState(() {
    //   _markers.add(Marker(
    //       onTap: () {
    //         print('Tapped');
    //       },
    //       draggable: true,
    //       markerId: MarkerId("0"),
    //       position: LatLng(6.927079, 79.861244),
    //       onDragEnd: (value) {
    //         print(value.latitude);
    //         print(value.longitude);
    //       }));
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers = Set.from([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppTopBar(title: "Map View")),
        drawer: DrawerWidget(),
        body: Stack(children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            //set the initial camera position to colombo
            initialCameraPosition:
                CameraPosition(target: LatLng(6.927079, 79.861244), zoom: 18),
            markers: _markers,
            myLocationEnabled: true,
            onTap: (position){
              Marker mark1 = Marker(
                markerId: MarkerId('"1"'),
                position: position
                );
                setState(() {
                  _markers.add(mark1);
                });
            },
            // myLocationButtonEnabled: true,
          )
        ]));
  }
}
