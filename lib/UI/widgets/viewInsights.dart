import 'package:blood_collector/models/insights_model.dart';
import 'package:blood_collector/shared/appConstant.dart';
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
  List<charts.Series<Insights, String>> _seriesPieData;
  List<InsightsModel> mydata;
  int bloodGroupAPlus = 0;
  int bloodGroupBPlus = 0;
  int bloodGroupABPlus = 0;
  int bloodGroupOPlus = 0;
  int bloodGroupANegitive = 0;
  int bloodGroupBNegitive = 0;
  int bloodGroupABNegitive = 0;
  int bloodGroupONegitive = 0;

  String bloodGroup;
  List<Insights> bloodGroupList;

  _getBloodGroupData(bloodGroupList) {
    _seriesPieData = List<charts.Series<Insights, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (Insights task, _) => task.insightDetails,
        measureFn: (Insights task, _) => task.insightValue,
        colorFn: (Insights task, _) =>
            charts.ColorUtil.fromDartColor(task.insightColor),
        id: 'tasks',
        data: bloodGroupList,
        labelAccessorFn: (Insights row, _) => "${row.insightValue}",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    bloodGroupList = [
      Insights("A+", Colors.red, bloodGroupAPlus),
      Insights("B+", Colors.red, bloodGroupBPlus),
      Insights("AB+", Colors.red, bloodGroupABPlus),
      Insights("O+", Colors.red, bloodGroupOPlus),
      Insights("A-", Colors.red, bloodGroupANegitive),
      Insights("B-", Colors.red, bloodGroupBNegitive),
      Insights("AB-", Colors.red, bloodGroupABNegitive),
      Insights("O-", Colors.red, bloodGroupONegitive),
    ];
    return Scaffold(
        appBar: AppBar(title: Text('Insights')), body: _buildChart());
  }

  Widget _buildChart() {
    _getBloodGroupData(bloodGroupList);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Time spent on daily tasks',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 5),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.startDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding: new EdgeInsets.only(
                            right: 4.0, bottom: 4.0, top: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.purple.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 18),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Insights {
  String insightDetails;
  int insightValue;
  Color insightColor;

  Insights(this.insightDetails, this.insightColor, this.insightValue);
}
