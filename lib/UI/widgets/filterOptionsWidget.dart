import 'package:flutter/material.dart';

class FilterOptions extends StatefulWidget {
  final ValueChanged<String> parentAction;

  const FilterOptions({Key key, this.parentAction}) : super(key: key);
  @override
  _FilterOptionsState createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  String selectedChoice = "All";

  List<String> filters = [
    "All",
    "Campaigns",
    "Requests",
  ];

  _buildChoiceList() {
    List<Widget> choices = List();
    filters.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.red[50],
          selectedColor: Colors.red[300],
          autofocus: true,
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
              widget.parentAction(selectedChoice);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 10,
        runSpacing: 4,
        children: _buildChoiceList(),
      ),
    );
  }
}
