import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostView extends StatefulWidget {
  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<CreatePostView> {
  final _formKey = GlobalKey<FormState>();

  File _image;
  final picker = ImagePicker();
  String description = '';
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(3, 6)),
          //BoxShadow
        ]);
  }

  Widget _eventDescription() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextField(
          minLines: 10,
          maxLines: 15,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'Write your status here',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  void _submitTheForm() {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      print('Form is vaild');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreatePostView()),
      );
    } else {
      print('Form is invaild');
    }
    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Post",
        ),
        elevation: 0.3,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              child: Text(
                "POST",
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
              onTap: () {},
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 18.0, bottom: 8.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Add a description",
                          style:
                              TextStyle(fontFamily: 'Roboto', fontSize: 17.0),
                        ),
                      ],
                    ),
                  ),
                  _eventDescription(),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, left: 18.0, bottom: 8.0, right: 18.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Upload a image",
                          style:
                              TextStyle(fontFamily: 'Roboto', fontSize: 17.0),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, left: 18.0, bottom: 8.0, right: 18.0),
                      child: _image == null
                          ? DottedBorder(
                              color: Colors.black,
                              padding: EdgeInsets.only(
                                top: 30,
                                right: 150,
                                bottom: 30,
                                left: 150,
                              ),
                              strokeWidth: 2,
                              radius: Radius.circular(12),
                              dashPattern: [6, 6],
                              child: Center(
                                child: Icon(
                                  Icons.backup,
                                  size: 90,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Container(
                              // height: 150,
                              width: double.infinity,
                              child: Image.file(_image, fit: BoxFit.fitHeight)),
                    ),
                    onTap: () {
                      _settingModalBottomSheet(context);
                    },
                  ),
                ],
              ))),
    ));
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () => {Navigator.pop(context), _getImage(true)}),
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Gallery'),
                  onTap: () => {Navigator.pop(context), _getImage(false)},
                ),
              ],
            ),
          );
        });
  }

  Future _getImage(bool isCamera) async {
    try {
      if (isCamera) {
        final pickedFile = await picker.getImage(source: ImageSource.camera);
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
