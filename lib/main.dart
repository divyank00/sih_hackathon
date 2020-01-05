import 'package:flutter/material.dart';
import 'package:sih_hackathon/Info/PInfo.dart';

import 'Auth/SignUp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Navigation",
      home: SignUp(),
    );
  }
}
