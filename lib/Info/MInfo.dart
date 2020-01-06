import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sih_hackathon/Info/CInfo.dart';

class MInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MInfo();
  }
}

class _MInfo extends State<MInfo> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController bloodController = TextEditingController();
  TextEditingController allergiesontroller = TextEditingController();
  TextEditingController medicationController = TextEditingController();
  TextEditingController medNotesController = TextEditingController();
  TextEditingController OrganDController = TextEditingController();
  TextEditingController addMController = TextEditingController();

  String blood, aller, medic, medN, ODonor,addM;

  final FocusNode _bloodFocus = FocusNode();
  final FocusNode _allerFocus = FocusNode();
  final FocusNode _medicFocus = FocusNode();
  final FocusNode _medNotesFocus = FocusNode();
  final FocusNode _OrganDonorFocus = FocusNode();
  final FocusNode _AddMFocus = FocusNode();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference User_UID = _firestore.collection("Users");

  bool flag;

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
        title: Text('Medical Information'),
      ),
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: _bloodFocus,
                    controller: bloodController,
                    onSaved: (value) {
                      blood = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) return 'This field cannot be empty!';
                      return null;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _bloodFocus, _allerFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: Image.asset('images/drop.png', height: 25,),
                        onPressed: null,
                      ),
                      hintText: 'For example, O+',
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
                      labelText: 'Blood Group',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
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
                    validator: (String value) {
                      return null;
                    },
                    focusNode: _allerFocus,
                    controller: allergiesontroller,
                    onSaved: (value) {
                      aller = value;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _allerFocus, _medicFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.do_not_disturb_alt,
                      ),
                      hintText: 'For example, peanuts',
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
                      labelText: 'Allergies',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.newline,
                    focusNode: _medicFocus,
                    controller: medicationController,
                    onSaved: (value) {
                      medic = value;
                    },
                    validator: (value) {
                      return null;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _medicFocus, _medNotesFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: Image.asset('images/med.png', height: 25,),
                        onPressed: null,
                      ),
                      hintText: 'For example, aspirin',
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
                      labelText: 'Medications',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
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
                    focusNode: _medNotesFocus,
                    controller: medNotesController,
                    onSaved: (value) {
                      medN = value;
                    },
                    validator: (value) {
                      return null;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(
                          context, _medNotesFocus, _OrganDonorFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.receipt),
                      hintText: 'For example, asthma',
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
                      labelText: 'Medical Notes',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
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
                    focusNode: _OrganDonorFocus,
                    controller: OrganDController,
                    onSaved: (value) {
                      ODonor = value;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _OrganDonorFocus, _AddMFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: Image.asset('images/heart.png'),
                        onPressed: null,
                      ),
                      hintText: 'Yes/No/Unknown',
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
                      labelText: 'Organ Donor',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.newline,
                    maxLines: null,
                    validator: (String value) {
                      return null;
                    },
                    focusNode: _AddMFocus,
                    controller: addMController,
                    onSaved: (value) {
                      addM = value;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _AddMFocus, null);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.add
                      ),
                      hintText: 'Additional Information for Emergency',
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
                      labelText: 'Additional Medical Information',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
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
                            await pDetails(blood, aller, medic, medN,ODonor,addM);
                        },
                        child: !flag ? Text('Next') : CircularProgressIndicator(),
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

  pDetails(String blood, String aller, String medic, String medN,
      String OD,String addMed) async {
    FirebaseUser _firebaseUser = await _firebaseAuth.currentUser();
    Map data = new HashMap<String, String>();
    data.putIfAbsent('bloodG', () => blood);
    if (aller.isNotEmpty)
      data.putIfAbsent('allergy', () => aller);
    else
      data.putIfAbsent('allergy', () => 'None');
    if (medic.isNotEmpty)
      data.putIfAbsent('medication', () => medic);
    else
      data.putIfAbsent('medication', () => 'Unknown');
    if (medN.isNotEmpty)
      data.putIfAbsent('medical_notes', () => medN);
    else
      data.putIfAbsent('medical_notes', () => 'Unknown');
    data.putIfAbsent('organDonor', () => OD);
    if (addMed.isNotEmpty)
      data.putIfAbsent('Additional_med_notes', () => addMed);
    else
      data.putIfAbsent('Add_med_notes', () => 'None');
    User_UID.document(_firebaseUser.uid).updateData(data).then((user) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CInfo()));
    });
  }
}
