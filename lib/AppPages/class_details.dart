import 'package:class_manager/AppPages/ClassDetails/class_info.dart';
import 'package:flutter/material.dart';

import 'ClassDetails/board_info.dart';
import 'ClassDetails/subject_info.dart';

class ClassDetails extends StatefulWidget {
  const ClassDetails({Key? key}) : super(key: key);

  @override
  _ClassDetailsState createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text("Class info"),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClassInfo()));
            },
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text("Board info"),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BoardInfo()));
            },
          ),
          ListTile(
            leading: Icon(Icons.architecture),
            title: Text("Subject info"),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SubjectInfo()));
            },
          ),
        ],
      ),
    );
  }
}
