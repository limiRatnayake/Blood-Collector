import 'package:blood_collector/UI/widgets/preventDooubleTap.dart';
import 'package:blood_collector/models/event_model.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/event_service.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewRequestDetails extends StatefulWidget {
  final String docRef;
  final String uid;
  ViewRequestDetails({Key key, this.docRef, this.uid}) : super(key: key);

  @override
  _ViewDetailsState createState() => _ViewDetailsState();
}

//timeline card
class _ViewDetailsState extends State<ViewRequestDetails> {
  @override
  Widget build(BuildContext context) {
    final EventService _eventServices = Provider.of<EventService>(context);
    final AuthServices _authServices = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //get user profile data
                  FutureBuilder(
                      future: _userService
                          .requestUserDetails(widget.uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          UserModel data =
                              UserModel.fromMap(snapshot.data.data);
                          return Column(
                            children: <Widget>[
                              Center(
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                    data.proPicUrl,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(data.firstName + " " + data.lastName),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          );
                        }
                      })
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Container(
              child: FutureBuilder(
                  future: _eventServices.requestEventsDetails(widget.docRef),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      EventModel data = EventModel.fromMap(snapshot.data.data);
                      var getRequestCloseDate =
                          DateTime.parse(data.requestClose);
                      String requestCloseDate =
                          DateFormat('yMd').format(getRequestCloseDate);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.opacity),
                              title: Text("Requested Blood Type"),
                              subtitle: Text(
                                data.bloodGroup,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.check_box_outline_blank),
                              title: Text("Units of Blood"),
                              subtitle: Text(data.unitsOfBlood),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            child: ListTile(
                                leading: Icon(Icons.event_available),
                                title: Text("When they need blood"),
                                subtitle: Text(requestCloseDate.toString())),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.local_hospital),
                              title: Text("Hospital Name"),
                              subtitle: Text(data.hospitalName),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.location_on),
                              title: Text("Hospital Address"),
                              subtitle: Text(data.hospitalAddress),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Card(
                            child: ListTile(
                              leading: Icon(Icons.phone),
                              title: Text("Contact Person Number"),
                              subtitle: Text(data.userPhoneNumber),
                              // trailing: Text(data.userPhoneNumber),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PreventDoubleTap(),
            ),
          ],
        ),
      ),
      // bottomSheet: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: PreventDoubleTap(),
      // ),
    );
  }
}
