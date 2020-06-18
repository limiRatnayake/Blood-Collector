import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HeroCampaignDetails extends StatefulWidget {
  @override
  HeroCampaignDetailsState createState() => HeroCampaignDetailsState();
}

class HeroCampaignDetailsState extends State<HeroCampaignDetails> {
  // Future<LocationData> _getUserLocation;
  LatLng _markerLocation;
  String _resultAddress;

  Set<Marker> _markers = HashSet<Marker>();
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers = Set.from([]);
  }

  getSetAddress(Coordinates coordinates) async {
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _resultAddress = addresses.first.addressLine;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Select a Place",
          ),
          elevation: 0.3,
        ),
        body: Container(
            color: Colors.white,
            child: Hero(
              tag: 'myMap',
              child: Stack(
                children: [
                  Container(
                      child: GoogleMap(
                    padding: EdgeInsets.all(0),
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(6.927079, 79.861244), zoom: 18),
                    markers: _markers,
                    myLocationEnabled: true,
                    onTap: (position) {
                      Marker mark1 =
                          Marker(markerId: MarkerId('"1'), position: position);
                      setState(() {
                        _markers.add(mark1);
                        _markerLocation = position;
                      });
                    },
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _resultAddress ?? "Address will be shown here",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton.icon(
                        label: Text("Selected Position"),
                        icon: Icon(Icons.location_on),
                        color: Colors.blue,
                        onPressed: () {
                          // Navigator.of(context).pop();
                          if (_markers.length < 1) {
                            print("no marker added");
                          } else {
                            print(_markers.first.position);
                            if (_markerLocation != null) {
                              getSetAddress(Coordinates(
                                  _markerLocation.latitude,
                                  _markerLocation.longitude));
                            }
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}

// import 'dart:async';
// import 'dart:collection';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class HeroCampaignDetails extends StatefulWidget {
//   @override
//   HeroCampaignDetailsState createState() => HeroCampaignDetailsState();
// }

// class HeroCampaignDetailsState extends State<HeroCampaignDetails> {
//   Set<Marker> _markers = HashSet<Marker>();
//   Completer<GoogleMapController> _controller = Completer();

//   void _onMapCreated(GoogleMapController controller) {
//     _controller.complete(controller);
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _markers = Set.from([]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Select a Place",
//           ),
//           elevation: 0.3,
//         ),
//         body: Container(
//             color: Colors.white,
//             child: Hero(
//               tag: 'myMap',
//               child: Stack(
//                 children: [
//                   Container(
//                       child: GoogleMap(
//                     padding: EdgeInsets.all(0),
//                     onMapCreated: _onMapCreated,
//                     initialCameraPosition: CameraPosition(
//                         target: LatLng(6.927079, 79.861244), zoom: 18),
//                     markers: _markers,
//                     myLocationEnabled: true,
//                     onTap: (position) {
//                       Marker mark1 = Marker(
//                           markerId: MarkerId('"1'), position: position);
//                       setState(() {
//                         _markers.add(mark1);
//                       });
//                     },
//                   )),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: FlatButton.icon(
//                         label: Text("Selected Position"),
//                         icon: Icon(Icons.location_on),
//                         color: Colors.blue,
//                         onPressed: () {
//                           // Navigator.of(context).pop();
//                           if(_markers.length<1){
//                             print("no marker added");
//                           }else{
//                             print(_markers.first.position);
//                           }
//                         },
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )));
//   }
// }
