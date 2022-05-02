import 'package:class_manager/AppPages/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Manager',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Class Manager"),
        ),
        body: HomePage()
      ),
    );
  }
}
