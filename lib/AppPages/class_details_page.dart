import 'package:class_manager/AppPages/board_details.dart';
import 'package:class_manager/AppPages/class_details.dart';
import 'package:class_manager/AppPages/subject_details.dart';
import 'package:flutter/material.dart';

class ClassDetailsPage extends StatefulWidget {
  const ClassDetailsPage({Key? key}) : super(key: key);

  @override
  _ClassDetailsPageState createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text("Class details page"),
        ),
        body:ListView(
          children: [
            ListTile(
              title: Text("Board details"),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BoardDetails())
                );
              },
            ),
            ListTile(
              title: Text("Subject"),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SubjectDetails())
                );
              },
            ),
            ListTile(
              title: Text("Class details"),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ClassDetails())
                );
              },
            ),
          ],
        ),

        ),
      );
  }
}

