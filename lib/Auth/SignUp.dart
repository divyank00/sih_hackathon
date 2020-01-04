import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUp();
  }
}

class _SignUp extends State<SignUp> {
  final _mailKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();
  final _repassKey = GlobalKey<FormState>();

  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController repassController = TextEditingController();

  String mail, password, repassword, SOS_ID;

  bool passwordVis, repasswordVis;

  final FocusNode _mailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _repassFocus = FocusNode();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  final DocumentReference doc = _firestore.collection("Users").document('1');

  @override
  void initState() {
    passwordVis = false;
    repasswordVis = false;
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
            padding: EdgeInsets.only(top: 40, left: 10, right: 10),
            child: Form(
              key: _mailKey,
              child: TextFormField(
                style: TextStyle(
                  color: Colors.black,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (String value) {
                  if (value.isEmpty) return 'This field cannot be empty.';
                  if (!isEmailValid(value)) return 'Format is incorrect.';
                  return null;
                },
                focusNode: _mailFocus,
                controller: mailController,
                onSaved: (value) {
                  mail = value;
                },
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _mailFocus, _passFocus);
                },
                decoration: InputDecoration(
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
            padding: EdgeInsets.only(top: 40, left: 10, right: 10),
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
                    return 'This field cannot be empty.';
                  }
                  if (!isPasswordValid(value)) {
                    return 'Password must be more than 6 characters';
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVis ? Icons.visibility : Icons.visibility_off,
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
            padding: EdgeInsets.only(top: 40, left: 10, right: 10),
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
                  if (value.isEmpty) return 'This field cannot be empty.';
                  if ((passController.text).compareTo(repassController.text) !=
                      0) return 'Password must be same.';
                  return null;
                },
                focusNode: _repassFocus,
                controller: repassController,
                onSaved: (value) {
                  repassword = value;
                },
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _repassFocus, null);
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      repasswordVis ? Icons.visibility : Icons.visibility_off,
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
            padding: EdgeInsets.all(12),
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  if (_mailKey.currentState.validate() &&
                      _passKey.currentState.validate() &&
                      _repassKey.currentState.validate()) {
                    _mailKey.currentState.save();
                    _passKey.currentState.save();
                    _repassKey.currentState.save();
                    return;
                  }
                  if (!_mailKey.currentState.validate()) {
                    mailController.clear();
                    passController.clear();
                    repassController.clear();
                  }
                  if (!_passKey.currentState.validate()) {
                    passController.clear();
                    repassController.clear();
                  }
                  if (!_repassKey.currentState.validate()) {
                    repassController.clear();
                  }
                });
              },
              child: Text('Sign Up'),
            ),
          )
        ],
      )),
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  bool isEmailValid(String email) {
    return EmailValidator.validate(email);
  }

  bool isPasswordValid(String password) {
    return password.length > 6;
  }
}
