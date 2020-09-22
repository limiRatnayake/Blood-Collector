import 'package:blood_collector/UI/pages/rootPages/donorSelectionCriteriaVIew.dart';
import 'package:blood_collector/UI/pages/rootPages/requestHistory.dart';
import 'package:blood_collector/models/user_model.dart';
import 'package:blood_collector/services/auth.dart';
import 'package:blood_collector/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class IntroSliderWidget extends StatefulWidget {
  @override
  _IntroSliderWidgetState createState() => _IntroSliderWidgetState();
}

class _IntroSliderWidgetState extends State<IntroSliderWidget> {
  int age;
  String birthDate;
  //craete a list of slides
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Image.asset(
          "assets/slide_one.png",
        ),
        titleWidget: Text(
          "Donor Selection Criteria",
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20.0),
        ),

        bodyWidget: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: '• Age above 18 years and below 60 years.',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      '• If previously donated, at least 4 months should be elapsed since the date of previous donation',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      '• Hemoglobin level should be more than 12g/dL. (this blood test is done prior to each blood donation)',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      '• Free from any serious disease condition or pregnancy.',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RichText(
                text: TextSpan(
                  text:
                      '• Should have a valid identity card or any other document to prove the identity.',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '• Free from "Risk Behaviours".',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(text: 'Free from "Risk Behaviours".'),
                  ],
                ),
              ),
            ],
          ),
        ),
        // body: "" ,
        decoration: PageDecoration(
          pageColor: Colors.red[50],
        ),
      ),
      PageViewModel(
          image: Image.asset(
            "assets/slide_two.png",
          ),
          titleWidget: Text(
            "Update Your Information",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          body: "It will help to give a better service",
          decoration: PageDecoration(
            pageColor: Colors.blue[50],
          ),
          footer: RaisedButton.icon(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DonorSelectionCriteriaPage()));
            },
            icon: Icon(
              Icons.edit,
            ),
            label: Text("Update"),
            color: Colors.blue.withOpacity(0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          )),
    ];
  }

  void calculateAge() {
    var selectedYear = DateTime.parse(birthDate);
    print(selectedYear);
    var currentYear = DateTime.now().year;
    setState(() {
      age = (currentYear - selectedYear.year).toInt();
      print(age);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices _authService = Provider.of<AuthServices>(context);
    final UserService _userService = Provider.of<UserService>(context);
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
          future: _userService.requestUserDetails(_authService.user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              UserModel data = UserModel.fromMap(snapshot.data.data);
              birthDate = data.birthDate;
              return IntroductionScreen(
                pages: getPages(),
                onDone: () {

                  if(data.availability == false){
                    //can't donate
                    
                    Alert(context: context, title: "Can't donate",).show();
                  }else if(data.availability != false && (age > 18 && age < 55)){
                    //can donate
                     Alert(context: context, title: "Can donate",).show();
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RequestHistory()));
                  }
                 
                },
                done: Text(
                  "Done",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                globalBackgroundColor: Colors.white,
                // showSkipButton: true,
                // skip: const Text("Skip"),
              );
            }
          }),
    ));
  }
}
