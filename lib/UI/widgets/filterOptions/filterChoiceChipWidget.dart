//packages
import 'package:flutter/material.dart';

class FilterChoiceChipWidget extends StatefulWidget {
  @override
  _FilterChoiceChipWidgetState createState() =>
      new _FilterChoiceChipWidgetState();
}

class _FilterChoiceChipWidgetState extends State<FilterChoiceChipWidget> {
  String selectedColomboAera = "";
  String selectedKandyAera = "";
  String selectedGalleAera = "";
  String selectedAmparaAera = "";
  String selectedAnuradhapuraAera = "";
  List<String> colomboArea = [
    "Angoda",
    "Authurugiriya",
    "Avissawella",
    "Battaramulla",
    "Boralesgamuwa",
    "Colombo 1",
    "Colombo 10",
    "Colombo 11",
    "Colombo 12",
    "Colombo 13",
    "Colombo 14",
    "Colombo 15",
    "Colombo 2",
    "Colombo 3",
    "Colombo 4",
    "Colombo 5",
    "Colombo 6",
    "Colombo 7",
    "Colombo 8",
    "Colombo 9",
    "Godagama",
    "Hanwella",
    "Kohuwala",
    "Homagama",
    "Piliyandala",
    "Dehiwala",
    "Nugegoda",
    "Maharagama",
  ];
  List<String> kandyArea = [
    "Akurana",
    "Gampola",
    "Peradeniya",
    "Katugastota",
    "Digana",
    "Ampitiya",
    "Galagedara",
  ];
  List<String> galleArea = [
    "Ambalangoda",
    "Elpitiya",
    "Hikkaduwa",
    "Baddegama",
    "Ahangama",
    "Batapola",
    "Bentota",
    "Karapitiya",
  ];
  List<String> amparaArea = [
    "Akkarepattu",
    "Kalmunai",
    "Ampara",
    "Sainthamaruthu",
  ];
  List<String> anuradhapuraArea = [
    "Angoda",
    "Authurugiriya",
    "Piliyandala",
    "Dehiwala",
    "Nugegoda",
    "Maharagama",
    "Colombo 6",
  ];

  _buildColomboChoiceList(List<String> name) {
    List<Widget> choices = List();
    name.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.white,
          selectedColor: Color(0xffffc107),
          selected: selectedColomboAera == item,
          onSelected: (selected) {
            setState(() {
              selectedColomboAera = item;
            });

            Navigator.pop(context, selectedColomboAera);
          },
        ),
      ));
    });
    return choices;
  }

  _buildKandyChoiceList(List<String> name) {
    List<Widget> choices = List();
    name.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.white,
          selectedColor: Color(0xffffc107),
          selected: selectedKandyAera == item,
          onSelected: (selected) {
            setState(() {
              selectedKandyAera = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  _buildGalleChoiceList(List<String> name) {
    List<Widget> choices = List();
    name.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.white,
          selectedColor: Color(0xffffc107),
          selected: selectedGalleAera == item,
          onSelected: (selected) {
            setState(() {
              selectedGalleAera = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  _buildAmaparaChoiceList(List<String> name) {
    List<Widget> choices = List();
    name.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.white,
          selectedColor: Color(0xffffc107),
          selected: selectedAmparaAera == item,
          onSelected: (selected) {
            setState(() {
              selectedAmparaAera = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 1,
        backgroundColor: Colors.white,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(5.0),
              child: Column(children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _areaTitleConatiner("Colombo")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Wrap(
                        children: _buildColomboChoiceList(colomboArea),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _areaTitleConatiner("Kandy")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Wrap(
                        children: _buildKandyChoiceList(kandyArea),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _areaTitleConatiner("Galle")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Wrap(
                        children: _buildGalleChoiceList(galleArea),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _areaTitleConatiner("Amapara")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Wrap(
                        children: _buildAmaparaChoiceList(amparaArea),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            // Positioned(
            //   // left: 5.0,
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.of(context).pop();
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Align(
            //         alignment: Alignment.topRight,
            //         child: CircleAvatar(
            //           backgroundColor: Colors.black.withOpacity(0.5),
            //           child: Icon(Icons.close, size: 25.0, color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ));
  }
}

Widget _areaTitleConatiner(String myTitle) {
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.red, fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}
