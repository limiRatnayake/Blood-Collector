//pages
import 'package:blood_collector/UI/pages/rootPages/donorSelectionCriteriaVIew.dart';
import 'package:blood_collector/UI/pages/rootPages/editPassword_view.dart';
import 'package:blood_collector/UI/pages/rootPages/editProfileView.dart';
import 'package:blood_collector/UI/pages/rootPages/notificationView.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:blood_collector/shared/decoration_constant.dart';
import 'package:blood_collector/UI/widgets/appTopBar.dart';
import 'package:blood_collector/UI/widgets/drawer_widget.dart';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  List months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];
  String lastDonationYear;
  String lastDonationMonth;
  String lastDonationDay;
  bool availableDate;

  @override
  void initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              Firestore.instance
                  .collection("users")
                  .document(currentUser.uid)
                  .get()
                  .then((DocumentSnapshot result) {
                if (result["dateOfLastDonation"] != null) {
                  var lastDonatedMonth =
                      DateTime.parse(result["dateOfLastDonation"]);
                  var currentMonth = DateTime.now();

                  var differenceInDays =
                      currentMonth.difference(lastDonatedMonth).inDays;
                  var differenceOfMonth = (differenceInDays) ~/ 30;
                  print(differenceOfMonth);

                  if (differenceOfMonth >= 4) {
                    availableDate = true;
                  } else {
                    availableDate = false;
                  }
                }
              })
            })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices _authServices = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);

    return Scaffold(
      // backgroundColor: Colors.grey.withOpacity(0.3),
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppTopBar(title: "Settings")),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                        future: _userService
                            .requestUserDetails(_authServices.user.uid),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            UserModel data =
                                UserModel.fromMap(snapshot.data.data);
                            DateTime lastDonationDate =
                                DateTime.parse(data.dateOfLastDonation);
                            lastDonationYear = lastDonationDate.year.toString();
                            lastDonationDay = lastDonationDate.day.toString();
                            lastDonationMonth =
                                DateFormat.MMMM().format(lastDonationDate);

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfileView()));
                                        })
                                  ],
                                ),
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
                                Text(
                                  data.firstName + " " + data.lastName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                      fontFamily: "Raleway"),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  data.email,
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                data.userRole != "User"
                                    ? Text(
                                        data.userRole,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 8.0,
                                ),
                                FlatButton.icon(
                                    onPressed: () {},
                                    icon: availableDate != true
                                        ? Icon(
                                            Icons.stars,
                                            size: 15,
                                            color: Colors.black,
                                          )
                                        : Icon(
                                            Icons.stars,
                                            size: 15,
                                            color: Colors.green,
                                          ),
                                    label: Text(
                                      "Available to Donate",
                                      style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.grey),
                                    )),
                                GridView.count(
                                    shrinkWrap: true,
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.99,
                                    padding: const EdgeInsets.all(10.0),
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0,
                                    children: <Widget>[
                                      Container(
                                        //get from constants
                                        decoration: settingData,

                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                data.bloodGroup,
                                                style: TextStyle(fontSize: 35),
                                              ),
                                              Text(
                                                "Blood Group",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black45),
                                              )
                                            ]),
                                      ),
                                      Container(
                                        decoration: settingData,
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(),
                                              Text(
                                                data.ifYesHowManyTimes
                                                    .toString(),
                                                style: TextStyle(fontSize: 35),
                                              ),
                                              Text(
                                                "Total Donations",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black45),
                                              )
                                            ]),
                                      ),
                                      Container(
                                        decoration: settingData,
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                lastDonationMonth +
                                                    "," +
                                                    " " +
                                                    lastDonationYear,
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              Text(
                                                lastDonationDay,
                                                style: TextStyle(fontSize: 35),
                                              ),
                                              Text(
                                                "Last Donation Date",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black45),
                                              )
                                            ]),
                                      ),
                                    ]),
                              ],
                            );
                          }
                        }),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
              Card(
                child: Column(children: <Widget>[
                  ListTile(
                    title: Text("Notification"),
                    leading: Icon(Icons.notifications),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationView()));
                    },
                  ),
                  ListTile(
                    title: Text("Privacy/Security"),
                    leading: Icon(Icons.lock_outline),
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EdiPasswordView()));
                      if (result != null) {
                        Scaffold.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text("$result")));
                      }
                    },
                  ),
                  ListTile(
                    title: Text("Donor Selection Criteria"),
                    leading: Icon(Icons.label_outline),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DonorSelectionCriteriaPage()));
                    },
                  ),
                  ListTile(
                    title: Text("Help"),
                    leading: Icon(Icons.help_outline),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text("About"),
                    leading: Icon(Icons.info_outline),
                    onTap: () {},
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
