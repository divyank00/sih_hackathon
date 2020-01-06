import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sih_hackathon/Auth/SignUp.dart';
import 'package:sih_hackathon/Screens/Home.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }
}

class _Login extends State<Login> {
  final _mailKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormState>();

  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String mail, password;

  bool passwordVis;

  final FocusNode _mailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference User_UID = _firestore.collection("Users");

  bool flag;

  @override
  void initState() {
    flag = false;
    passwordVis = true;
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
              key: _mailKey,
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
                focusNode: _mailFocus,
                controller: mailController,
                onSaved: (value) {
                  mail = value;
                },
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _mailFocus, _passFocus);
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
                textInputAction: TextInputAction.done,
                validator: (String value) {
                  if (value.isEmpty) return 'This field cannot be empty!';
                  return null;
                },
                focusNode: _passFocus,
                controller: passController,
                onSaved: (value) {
                  password = value;
                },
                onFieldSubmitted: (term) {
                  _fieldFocusChange(context, _passFocus, null);
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
            padding: EdgeInsets.all(30),
            child: Container(
              height: 50,
              child: RaisedButton(
                onPressed: () async {
                  setState(() {
                    flag = true;
                  });
                  setState(() {
                    if (_mailKey.currentState.validate() &&
                        _passKey.currentState.validate()) {
                      _mailKey.currentState.save();
                      _passKey.currentState.save();
                      flag = true;
                    } else {
                      if (!_mailKey.currentState.validate()) {
                        mailController.clear();
                        passController.clear();
                        passwordVis = true;
                        flag = false;
                      }
                      if (!_passKey.currentState.validate()) {
                        passController.clear();
                        passwordVis = true;
                        flag = false;
                      }
                    }
                  });
                  if (flag) await Sign_In(mail, password);
                },
                child: !flag ? Text('Sign In') : CircularProgressIndicator(),
              ),
            ),
          ),
          SizedBox(
            height: 80,
          ),
          Text('Register?',),
          Container(
            padding: EdgeInsets.only(top: 5),
            height: 50,
            child: RaisedButton(
                child: Text('Sign Up'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return SignUp();
                  }));
                }),
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

  Sign_In(String mail, String password) async {
    await _firebaseAuth
        .signInWithEmailAndPassword(email: mail, password: password)
        .then((authResult) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
      _firebaseAuth.signOut();
      setState(() {
        flag = false;
      });
    });
  }
}
