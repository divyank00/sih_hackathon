import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sih_hackathon/Auth/Login.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Home();
  }
}

class _Home extends State<Home>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
          child: Container(
            padding: EdgeInsets.only(top: 5),
            height: 50,
            child: RaisedButton(
                child: Text('Log Out'),
                onPressed: () async {
                  await _firebaseAuth.signOut().then((user) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return Login();
                        }));
                  });
                }),
          )
      ),
    );
  }

}