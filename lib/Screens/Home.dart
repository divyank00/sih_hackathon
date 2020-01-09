import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:map_launcher/map_launcher.dart';
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

  List<Placemark> placemark;

  Placemark location;

  bool flag;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flag = false;
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
                height: 600,
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

  Future getLocation() async {
    placemark = await Geolocator().placemarkFromCoordinates(lat, long);
    location = placemark[0];
  }

//  openMaps() {
//    String origin = "somestartLocationStringAddress or lat,long"; // lat,long like 123.34,68.56
//    String destination = "$lat,$long";
//    if (new LocalPlatform().isAndroid) {
//      final AndroidIntent intent = new AndroidIntent(
//          action: 'action_view',
//          data: Uri.encodeFull(
//              "https://www.google.com/maps/dir/?api=1&origin=" +
//                  origin + "&destination=" + destination +
//                  "&travelmode=driving&dir_action=navigate"),
//          package: 'com.google.android.apps.maps');
//      intent.launch();
//    }
//    else {
//      String url = "https://www.google.com/maps/dir/?api=1&origin=" + origin +
//          "&destination=" + destination +
//          "&travelmode=driving&dir_action=navigate";
//      if (await canLaunch (url))
//        await launch(url);
//      else
//    throw 'Could not launch $url';
//    }
//  }

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
          SizedBox(
            height: 10,
          ),
          flag ?
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width - 40,
            alignment: Alignment.center,
            child: SelectableText(
              'Location: ${location.name}, ${location
                  .subThoroughfare}, ${location
                  .thoroughfare}, ${location.subLocality}, ${location
                  .locality}, ${location.postalCode}, ${location.country}',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ) :
          SizedBox(
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 130,
              child: RaisedButton(
                onPressed: () async {
                  await getLocation();
                  setState(() {
                    flag = true;
                  });
                },
                child: Text('Get Location'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 130,
              child: RaisedButton(
                onPressed: () async {
//                    if (await MapLauncher.isMapAvailable(MapType.google)) {
//                    await MapLauncher.launchMap(
//                    mapType: MapType.google,
//                    coords: Coords(lat, long),
//                      title: 'Accident Spot',
//                      description: 'Hi',

//                  final availableMaps = await MapLauncher.installedMaps;
//                  print(
//                      availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
//
//                  await availableMaps.first.showMarker(
//                    coords: Coords(31.233568, 121.505504),
//                    title: "Shanghai Tower",
//                    description: "Asia's tallest building",
//                  );
                },
                child: Text('Navigate'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}