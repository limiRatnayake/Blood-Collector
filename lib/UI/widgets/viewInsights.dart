import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TaskHomePage extends StatefulWidget {
  final String docRef;

  const TaskHomePage({Key key, this.docRef}) : super(key: key);
  @override
  _TaskHomePageState createState() {
    return _TaskHomePageState();
  }
}

class _TaskHomePageState extends State<TaskHomePage> {
  List<charts.Series<BloodGroupInsights, String>> _seriesBloodGroupData;
  List<charts.Series<GenderInsights, String>> _seriesGenderData;
  List<charts.Series<GenderInsights, String>> _seriesAgeData;
  // List<BloodGroupInsights> mydata;
  int bloodGroupAPlus = 0;
  int bloodGroupBPlus = 0;
  int bloodGroupABPlus = 0;
  int bloodGroupOPlus = 0;
  int bloodGroupANegitive = 0;
  int bloodGroupBNegitive = 0;
  int bloodGroupABNegitive = 0;
  int bloodGroupONegitive = 0;
  int female = 0;
  int male = 0;

  String bloodGroup;
  String gender;
  String birthDate;
  int age;
  List<BloodGroupInsights> bloodGroupList;
  List<GenderInsights> genderList;
  List<AgeInsights> ageList;

  _getBloodGroupData(bloodGroupList) {
    _seriesBloodGroupData = List<charts.Series<BloodGroupInsights, String>>();
    _seriesBloodGroupData.add(
      charts.Series(
        domainFn: (BloodGroupInsights task, _) => task.insightDetails,
        measureFn: (BloodGroupInsights task, _) => task.insightValue,
        colorFn: (BloodGroupInsights task, _) =>
            charts.ColorUtil.fromDartColor(task.insightColor),
        id: 'tasks',
        data: bloodGroupList,
        labelAccessorFn: (BloodGroupInsights row, _) => "${row.insightValue}",
      ),
    );
  }

  _getGenderData(genderList) {
    _seriesGenderData = List<charts.Series<GenderInsights, String>>();
    _seriesGenderData.add(
      charts.Series(
        domainFn: (GenderInsights gender, _) => gender.genderDetails,
        measureFn: (GenderInsights gender, _) => gender.genderValue,
        colorFn: (GenderInsights gender, _) =>
            charts.ColorUtil.fromDartColor(gender.genderColor),
        id: 'tasks',
        data: genderList,
        labelAccessorFn: (GenderInsights row, _) => "${row.genderDetails}",
      ),
    );
  }

  _getBloodGroupValues() {
    Firestore.instance
        .collection("participants")
        .where("docRef", isEqualTo: widget.docRef)
        // .where("participatedStatus", isEqualTo: "Donated")
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((element) {
              bloodGroup = element.data["bloodGroup"];

              switch (bloodGroup) {
                case "A+":
                  {
                    setState(() {
                      bloodGroupAPlus = bloodGroupAPlus + 1;
                    });
                  }
                  break;
                case "B+":
                  {
                    setState(() {
                      bloodGroupBPlus = bloodGroupBPlus + 1;
                    });
                  }
                  break;
                case "AB+":
                  {
                    setState(() {
                      bloodGroupABPlus = bloodGroupABPlus + 1;
                    });
                  }
                  break;
                case "O+":
                  {
                    setState(() {
                      bloodGroupOPlus = bloodGroupOPlus + 1;
                    });
                  }
                  break;
                case "A-":
                  {
                    setState(() {
                      bloodGroupANegitive = bloodGroupANegitive + 1;
                    });
                  }
                  break;
                case "B-":
                  {
                    setState(() {
                      bloodGroupBNegitive = bloodGroupBNegitive + 1;
                    });
                  }
                  break;
                case "AB-":
                  {
                    setState(() {
                      bloodGroupABNegitive = bloodGroupABNegitive + 1;
                    });
                  }
                  break;
                case "O-":
                  {
                    setState(() {
                      bloodGroupONegitive = bloodGroupONegitive + 1;
                    });
                  }
                  break;

                default:
                  {
                    print("No Data");
                  }
                  break;
              }
            }));
  }

  _getAllUserValues() {
    String uid;
    Firestore.instance
        .collection("participants")
        .where("docRef", isEqualTo: widget.docRef)
        .getDocuments()
        .then((QuerySnapshot snapshot) => snapshot.documents.forEach((element) {
              uid = element.data["uid"];
              Firestore.instance
                  .collection("users")
                  .where("uid", isEqualTo: uid)
                  .getDocuments()
                  .then((QuerySnapshot userSnapshot) =>
                      userSnapshot.documents.forEach((userData) {
                        gender = userData.data["gender"];
                        birthDate = userData.data["birthDate"];

                        var dateOfBirth = DateTime.parse(birthDate);

                        var currentYear = DateTime.now().year;
                        setState(() {
                          age = (currentYear - dateOfBirth.year).toInt();
                          print(age);
                        });
                        switch (gender) {
                          case "Male":
                            {
                              setState(() {
                                male = male + 1;
                              });
                            }
                            break;
                          case "Female":
                            {
                              setState(() {
                                female = female + 1;
                              });
                            }
                            break;
                          default:
                        }
                        if (18 <= 24) {
                          setState(() {
                            male = male + 1;
                          });
                        } else if (25 <= 34) {
                        } else if (35 <= 44) {
                        } else if (45 <= 54) {
                        } else if (54 <= 60) {}
                      }));
            }));
  }

  @override
  void initState() {
    super.initState();
    _getBloodGroupValues();
    _getAllUserValues();
  }

  @override
  Widget build(BuildContext context) {
    bloodGroupList = [
      BloodGroupInsights("A+", Colors.teal, bloodGroupAPlus),
      BloodGroupInsights("B+", Colors.cyan, bloodGroupBPlus),
      BloodGroupInsights("AB+", Colors.yellow[700], bloodGroupABPlus),
      BloodGroupInsights("O+", Colors.blue, bloodGroupOPlus),
      BloodGroupInsights("A-", Colors.indigo, bloodGroupANegitive),
      BloodGroupInsights("B-", Colors.purple, bloodGroupBNegitive),
      BloodGroupInsights("AB-", Colors.lime, bloodGroupABNegitive),
      BloodGroupInsights("O-", Colors.lightBlue, bloodGroupONegitive),
    ];
    genderList = [
      GenderInsights("Male", male, Colors.blue),
      GenderInsights("Female", female, Colors.blue[900]),
    ];
    return Scaffold(
        appBar: AppBar(title: Text('Analytics')),
        body: SingleChildScrollView(child: _buildChart()));
  }

  Widget _buildChart() {
    _getBloodGroupData(bloodGroupList);
    _getGenderData(genderList);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              elevation: 1,
              child: Column(
                children: <Widget>[
                  Text(
                    'Participant Donors Blood  Group Types',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                      child: charts.BarChart(
                    _seriesBloodGroupData,
                    // animate: true,
                    // animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding: new EdgeInsets.only(
                          right: 4.0,
                          bottom: 4.0,
                        ),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 15),
                      )
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              elevation: 1,
              child: Column(
                children: <Widget>[
                  Text(
                    'Gender',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: charts.PieChart(_seriesGenderData,
                        animate: true,
                        animationDuration: Duration(seconds: 5),
                        behaviors: [
                          new charts.DatumLegend(
                            outsideJustification:
                                charts.OutsideJustification.endDrawArea,
                            horizontalFirst: false,
                            desiredMaxRows: 2,
                            cellPadding: new EdgeInsets.only(
                              right: 4.0,
                              bottom: 4.0,
                            ),
                            entryTextStyle: charts.TextStyleSpec(
                                color:
                                    charts.MaterialPalette.purple.shadeDefault,
                                fontFamily: 'Georgia',
                                fontSize: 10),
                          )
                        ],
                        defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 80,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(
                                  insideLabelStyleSpec:
                                      new charts.TextStyleSpec(
                                          fontSize: 18, // size in Pts.
                                          color: charts.MaterialPalette.white),
                                  labelPosition: charts.ArcLabelPosition.inside)
                            ])),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BloodGroupInsights {
  String insightDetails;
  int insightValue;
  Color insightColor;

  BloodGroupInsights(this.insightDetails, this.insightColor, this.insightValue);
}

class GenderInsights {
  String genderDetails;
  int genderValue;
  Color genderColor;

  GenderInsights(this.genderDetails, this.genderValue, this.genderColor);
}

class AgeInsights {
  String ageGap;
  int ageValue;
  Color ageColor;

  AgeInsights(this.ageGap, this.ageValue, this.ageColor);
}
