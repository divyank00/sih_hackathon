import 'package:flutter/material.dart';
import 'Auth/SignUp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Navigation",
        home: SignUp(),
    );
  }
}
