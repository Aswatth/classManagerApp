import 'package:class_manager/AppPages/StudentPages/add_student.dart';
import 'package:class_manager/AppPages/StudentPages/student_list.dart';
import 'package:flutter/material.dart';

class StudentInfo extends StatefulWidget {
  const StudentInfo({Key? key}) : super(key: key);

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Student list"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => StudentList(),));
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text("View fees details"),
            onTap: (){
            },
          ),
        ],
      ),
    );
  }
}
