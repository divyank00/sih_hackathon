import 'dart:async';
import 'dart:collection';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
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
  final CollectionReference SOS_UID = _firestore.collection("SOS");
  final CollectionReference User_UID = _firestore.collection("Users");


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

  bool flag, flag1, flag2, temp, temp1;


  String localFilePath;

  static AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = new AudioCache(fixedPlayer: audioPlayer);

  play() {
    temp = true;
    audioCache.loop('ring.mp3', stayAwake: true, isNotification: true);
  }

  stop() {
    audioPlayer.stop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    temp = false;
    temp1 = true;
    flag = false;
    flag1 = false;
    flag2 = false;
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: accident.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                return Container(
                  height: 300,
                  child: new Column(
                    children: snapshot.data.documents.map((
                        DocumentSnapshot document) {
                      if (document.exists) {
                        if (document['users'] != null) {
                          list = List<String>.from(document['users']);
                          if (list.contains(UID)) {
                            if (document['flag'] == true) {
                              long = document['Longitude'];
                              lat = document['Latitude'];
                              if (temp1)
                                play();
                              return cardB();
                            }
                            else {
                              if (temp) {
                                stop();
                                temp = false;
                              }
                            }
                          }
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
                      child: Text('Find My Car'),
                      onPressed: () async {
                        setState(() {
                          flag2 = true;
                        });
                        await getCoordinates();
                      }),
                )
            ),
            SizedBox(
              height: 20,
            ),
            flag2 ? CircularProgressIndicator() : SizedBox(height: 0),
            flag1 ?
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
                    color: Colors.black
                ),
              ),
            ) :
            SizedBox(
              height: 0,
            ),
            flag1 ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 130,
                child: RaisedButton(
                  onPressed: () async {
                    if (await MapLauncher.isMapAvailable(MapType.google)) {
                      await MapLauncher.launchMap(
                        mapType: MapType.google,
                        coords: Coords(lat, long),
                        title: 'Accident Spot',
                        description: 'Your car is here!',
                      );
                    }
                    else if (await MapLauncher.isMapAvailable(MapType.apple)) {
                      await MapLauncher.launchMap(
                        mapType: MapType.apple,
                        coords: Coords(lat, long),
                        title: 'Accident Spot',
                        description: 'Your car is here!',
                      );
                    }
                    else {
                      final availableMaps = await MapLauncher.installedMaps;
                      await availableMaps.first.showMarker(
                        coords: Coords(lat, long),
                        title: "Accident Spot",
                        description: "Your car is here!",
                      );
                    }
                  },
                  child: Text('Navigate'),
                ),
              ),
            ) :
            SizedBox(
              height: 0,
            ),
            SizedBox(
                height: 100
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
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return Login();
                                  }));
                        });
                      }),
                )
            ),
          ],
        ),
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

  getCoordinates() async {
    String SOS_ID;
    await User_UID.document(UID).get().then((DS) {
      if (DS.exists)
        SOS_ID = DS['SOS_ID'];
    });
    Map map = HashMap<String, bool>();
    map.putIfAbsent('getLocation', () => true);
    await SOS_UID.document(SOS_ID).updateData(map);
    Future.delayed(Duration(seconds: 5));
    await SOS_UID.document(SOS_ID).get().then((DS) {
      if (DS.exists) {
        long = DS['Longitude'];
        lat = DS['Latitude'];
      }
    });
    await getLocation();
    setState(() {
      flag1 = true;
      flag2 = false;
    });
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
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 130,
                  child: RaisedButton(
                    onPressed: () async {
                      if (await MapLauncher.isMapAvailable(MapType.google)) {
                        await MapLauncher.launchMap(
                          mapType: MapType.google,
                          coords: Coords(lat, long),
                          title: 'Accident Spot',
                          description: 'Your car is here!',
                        );
                      }
                      else
                      if (await MapLauncher.isMapAvailable(MapType.apple)) {
                        await MapLauncher.launchMap(
                          mapType: MapType.apple,
                          coords: Coords(lat, long),
                          title: 'Accident Spot',
                          description: 'Your car is here!',
                        );
                      }
                      else {
                        final availableMaps = await MapLauncher.installedMaps;
                        await availableMaps.first.showMarker(
                          coords: Coords(lat, long),
                          title: "Accident Spot",
                          description: "Your car is here!",
                        );
                      }
                    },
                    child: Text('Navigate'),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: Image.asset('images/silent.jpg', color: Colors.white),
                    tooltip: 'Silent',
                    splashColor: temp1 ? Colors.white : Colors.red.shade900,
                    highlightColor: temp1 ? Colors.white : Colors.red.shade900,
                    onPressed: () {
                      if (temp1)
                        stop();
                      setState(() {
                        temp1 = false;
                      });
                    }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}