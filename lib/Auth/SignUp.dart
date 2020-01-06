import 'dart:collection';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sih_hackathon/Info/PInfo.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUp();
  }
}

class _SignUp extends State<SignUp> {
  final _contactKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();
  final _repassKey = GlobalKey<FormState>();
  final _IDKey = GlobalKey<FormState>();


  TextEditingController contactController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController repassController = TextEditingController();
  TextEditingController IDController = TextEditingController();

  String contact, password, repassword, SOS_ID;

  bool passwordVis, repasswordVis;

  final FocusNode _contactFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _repassFocus = FocusNode();
  final FocusNode _IDFocus = FocusNode();


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference SOS_UID = _firestore.collection("SOS");
  final CollectionReference User_UID = _firestore.collection("Users");

  bool result, flag;

  @override
  void initState() {
    result = false;
    flag = false;
    passwordVis = true;
    repasswordVis = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS'),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                child: Form(
                  key: _contactKey,
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (String value) {
                      if (value.isEmpty) return 'This field cannot be empty!';
                      if (!isEmailValid(value)) return 'Invalid E-Mail!';
                      return null;
                    },
                    focusNode: _contactFocus,
                    controller: contactController,
                    onSaved: (value) {
                      contact = value;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _contactFocus, _passFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail,
                      ),
                      hintText: 'Enter E-Mail',
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
                      labelText: 'E-Mail',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                child: Form(
                  key: _passKey,
                  child: TextFormField(
                    autocorrect: false,
                    obscureText: passwordVis,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'This field cannot be empty!';
                      }
                      if (!isPasswordValid(value)) {
                        return 'Password must be more than 6 characters!';
                      }
                      return null;
                    },
                    focusNode: _passFocus,
                    controller: passController,
                    onSaved: (value) {
                      password = value;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _passFocus, _repassFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.enhanced_encryption,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVis ? Icons.visibility_off : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVis = !passwordVis;
                          });
                        },
                      ),
                      hintText: 'Enter Password',
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
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                child: Form(
                  key: _repassKey,
                  child: TextFormField(
                    autocorrect: false,
                    obscureText: repasswordVis,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    validator: (String value) {
                      if (value.isEmpty) return 'This field cannot be empty!';
                      if ((passController.text).compareTo(
                          repassController.text) !=
                          0) return 'Password must be same!';
                      return null;
                    },
                    focusNode: _repassFocus,
                    controller: repassController,
                    onSaved: (value) {
                      repassword = value;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _repassFocus, _IDFocus);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.enhanced_encryption,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          repasswordVis ? Icons.visibility_off : Icons
                              .visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            repasswordVis = !repasswordVis;
                          });
                        },
                      ),
                      hintText: 'Re-Enter Password',
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
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                child: Form(
                  key: _IDKey,
                  child: TextFormField(
                    maxLines: null,
                    autocorrect: false,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    validator: (String value) {
                      if (value.isEmpty) return 'This field cannot be empty!';
                      if (!result) return 'Invalid QR Code';
                      return null;
                    },
                    focusNode: _IDFocus,
                    controller: IDController,
                    onSaved: (value) {
                      SOS_ID = value;
                    },
                    onFieldSubmitted: (term) {
                      _fieldFocusChange(context, _IDFocus, null);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.directions_car,
                      ),
                      suffixIcon: IconButton(
                        iconSize: 40,
                        icon: Image.asset('images/qr.jpg',
                        ),
                        onPressed: () {
                          setState(() {
                            _scanQR();
                          });
                        },
                      ),
                      hintText: 'Scan QR',
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
                      labelText: 'SOS ID',
                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    onPressed: () async {
                      setState(() {
                        flag = true;
                      });
                      result = await isIDValid(IDController.text);
                      setState(() {
                        if (_contactKey.currentState.validate() &&
                            _passKey.currentState.validate() &&
                            _repassKey.currentState.validate() &&
                            _IDKey.currentState.validate() &&
                            result) {
                          _contactKey.currentState.save();
                          _passKey.currentState.save();
                          _repassKey.currentState.save();
                          _IDKey.currentState.save();
                          flag = true;
                        }
                        else {
                          if (!_contactKey.currentState.validate()) {
                            contactController.clear();
                            passController.clear();
                            repassController.clear();
                            IDController.clear();
                            passwordVis = true;
                            repasswordVis = true;
                            flag = false;
                          }
                          if (!_passKey.currentState.validate()) {
                            passController.clear();
                            repassController.clear();
                            passwordVis = true;
                            repasswordVis = true;
                            flag = false;
                          }
                          if (!_repassKey.currentState.validate()) {
                            repassController.clear();
                            passwordVis = true;
                            repasswordVis = true;
                            flag = false;
                          }
                          if (!_IDKey.currentState.validate() && !result) {
                            IDController.clear();
                            flag = false;

                          }
                        }
                      });
                      if (flag)
                        await Sign_Up(contact, password);
                    },
                    child: !flag
                        ? Text('Sign Up')
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus,
      FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  bool isEmailValid(String email) {
    return EmailValidator.validate(email);
  }

  bool isPasswordValid(String password) {
    return password.length > 6;
  }

  Future<bool> isIDValid(String UID) async {
    if (UID.isEmpty)
      return false;
    var snapshot = await SOS_UID.document(UID).get();
    return snapshot.exists;
  }

  Future _scanQR() async {
    String result = '';
    try {
      result = await BarcodeScanner.scan();
      setState(() {
        IDController.text = result;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        Fluttertoast.showToast(msg: 'Camera permission was denied!',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIos: 2);
      }
      else
        Fluttertoast.showToast(msg: 'Unknown Error: $e',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIos: 2);
    } on FormatException {
      Fluttertoast.showToast(
          msg: 'You pressed the back button before scanning anything!',
          toastLength: Toast.LENGTH_LONG, timeInSecForIos: 2);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unknown Error: $e',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 2);
    }
  }

  Sign_Up(String contact, String password) async {
    bool flag1 = true;
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: contact, password: password).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      _firebaseAuth.signOut();
      setState(() {
        flag = false;
      });
      flag1 = false;
    });
    if (flag1) {
      FirebaseUser _firebaseUser = await _firebaseAuth.currentUser();
      Map data = new HashMap<String, String>();
      data.putIfAbsent('E-Mail', () => contact);
      data.putIfAbsent('SOS_ID', () => SOS_ID);
      User_UID
          .document(_firebaseUser.uid)
          .setData(data)
          .then((user) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PInfo()));
      });
    }
//    await _firebaseAuth.signInWithEmailAndPassword(
//        email: contact, password: password).catchError((e) {
//      Fluttertoast.showToast(msg: e.toString());
//    });
//    Navigator.pushReplacement(context,
//            MaterialPageRoute(builder: (context) => PInfo()));
  }
}


