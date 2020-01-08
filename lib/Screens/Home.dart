import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sih_hackathon/Auth/Login.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Home();
  }
}

class _Home extends State<Home>{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference accident = _firestore.collection("accident");

//  final Firestore _db = Firestore.instance;
//  final FirebaseMessaging _fcm = FirebaseMessaging();
//  StreamSubscription iosSubscription;
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    if (Platform.isIOS) {
//      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
//        // save the token  OR subscribe to a topic here
//      });
//
//      _fcm.requestNotificationPermissions(IosNotificationSettings());
//    }
//    _fcm.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//        showDialog(
//          context: context,
//          builder: (context) => AlertDialog(
//            content: ListTile(
//              title: Text(message['notification']['title']),
//              subtitle: Text(message['notification']['body']),
//            ),
//            actions: <Widget>[
//              FlatButton(
//                child: Text('Ok'),
//                onPressed: () => Navigator.of(context).pop(),
//              ),
//            ],
//          ),
//        );
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
//        // TODO optional
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//        // TODO optional
//      },
//    );
//  }
  FirebaseUser user;
  String UID;

  double long, lat;

  String user1;
  List<String> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUID().then((user1) {
      UID = user1.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: accident.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              return Container(
                height: 200,
                child: new Column(
                  children: snapshot.data.documents.map((
                      DocumentSnapshot document) {
                    if (document['users'] != null  && document['flag'] == true) {
                      list = List<String>.from(document['users']);
                      if (list.contains(UID)) {
                        long = document['Longitude'];
                        lat = document['Latitude'];
                        return cardB();
                      }
                    }
                    return SizedBox(
                      height: 0,
                    );
                  }).toList(),
                ),
              );
            },
          ),
          Center(
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
        ],
      ),
    );
  }

  Future<FirebaseUser> getUID() async {
    return user = await _firebaseAuth.currentUser();
  }

  Widget cardB() {
    return Card(
      color: Colors.red.shade900,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 30,
              child: Text('Emergency! Your Car Has Met With An Accident!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30, color: Colors.white,
                    fontWeight: FontWeight.bold
                ),),
            ),
          ),

          Text('lat:$lat   long:$long'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 130,
              child: RaisedButton(
                onPressed: () {},
                child: Text('Navigate'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}