import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sih_hackathon/Screens/Home.dart';

class CInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CInfo();
  }
}

class _CInfo extends State<CInfo> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController cMController = TextEditingController();
  TextEditingController cNController = TextEditingController();
  TextEditingController cCController = TextEditingController();
  TextEditingController cSController = TextEditingController();
  TextEditingController idenController = TextEditingController();

  String cM, cN, cC, cS, iden;

  final FocusNode _cMFocus = FocusNode();
  final FocusNode _cNFocus = FocusNode();
  final FocusNode _cCFocus = FocusNode();
  final FocusNode _cSFocus = FocusNode();
  final FocusNode _idenFocus = FocusNode();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference User_UID = _firestore.collection("Users");

  bool flag;

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    flag = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Additional Information'),
      ),
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 10),
                      child: Text(
                        'Vehicle Information',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, left: 5, right: 10),
                        child: Divider(
                          color: Colors.red.shade600,
                          thickness: 1.5,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: _cMFocus,
                    controller: cMController,
                    onSaved: (value) {
                      cM = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'This field cannot be empty!';
                      return null;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _cMFocus, _cNFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.directions_car
                      ),
                      hintText: 'For example, Mahindra XUV300',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.green.shade600, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      labelText: 'Car Model',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (String value) {
                      if (value.isEmpty) return 'This field cannot be empty!';
                      return null;
                    },
                    focusNode: _cNFocus,
                    controller: cNController,
                    onSaved: (value) {
                      cN = value;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _cNFocus, _cCFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.crop_16_9,
                      ),
                      hintText: 'For example, MH01AE8017',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.green.shade600, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      labelText: 'Car Number',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: _cCFocus,
                    controller: cCController,
                    onSaved: (value) {
                      cC = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'This field cannot be empty!';
                      return null;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _cCFocus, _cSFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.color_lens
                      ),
                      hintText: 'For example, Red',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.green.shade600, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      labelText: 'Car Color',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    focusNode: _cSFocus,
                    controller: cSController,
                    onSaved: (value) {
                      cS = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'This field cannot be empty!';
                      return null;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(
                          context, _cSFocus, null);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.airline_seat_recline_normal),
                      hintText: 'For example, 6',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.green.shade600, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      labelText: 'Number of Seats',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, left: 10),
                      child: Text(
                        'Identification',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40, left: 5, right: 10),
                        child: Divider(
                          color: Colors.red.shade600,
                          thickness: 1.5,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 40,
                        child: Text(
                          'This section is to identify whether the Accident Victim is someone else.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: TextFormField(
                    maxLines: null,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.newline,
                    focusNode: _idenFocus,
                    controller: idenController,
                    onSaved: (value) {
                      iden = value;
                    },
                    validator: (value) {
                      return null;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _idenFocus, null);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.person
                      ),
                      hintText: 'For example, Tattoo on back',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.green.shade600, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      labelText: 'Identification Mark',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                IconButton(
                  icon: _image == null ? Icon(Icons.add) : Image.file(_image),
                  onPressed: () {
                    getImage();
                  },
                  tooltip: 'Pick Image',
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Container(
                      height: 50,
                      child: RaisedButton(
                        onPressed: () async {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              flag = true;
                            } else {
                              flag = false;
                            }
                          });
                          if (flag)
                            await pDetails(cM, cN, cC, cS, iden);
                        },
                        child: !flag
                            ? Text('Done')
                            : CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  pDetails(String carM, String carN, String carC, String carS,
      String IM) async {
    FirebaseUser _firebaseUser = await _firebaseAuth.currentUser();
    Map data = new HashMap<String, String>();
    data.putIfAbsent('Model', () => carM);
    data.putIfAbsent('Number', () => carN);
    data.putIfAbsent('Color', () => carC);
    data.putIfAbsent('Seater', () => carS);
    if (IM.isNotEmpty)
      data.putIfAbsent('Identification', () => IM);
    else
      data.putIfAbsent('Identification', () => 'None');
    User_UID.document(_firebaseUser.uid).updateData(data).then((user) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    });
  }
}
