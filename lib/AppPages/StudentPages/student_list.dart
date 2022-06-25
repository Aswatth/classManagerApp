import 'package:class_manager/AppPages/StudentPages/student_profile.dart';
import 'package:class_manager/Model/student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_student.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

  List<StudentModel> _studentList = [];
  
  Future<void> getAllStudent()async{
    List<StudentModel> temp = await StudentHelper.instance.getAllStudent();
    setState(() {
      _studentList = temp;
    });
  }

  Widget studentWidget(StudentModel student){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text(student.name),
              trailing: Text(student.className),
            ),
            ListTile(
              leading: Icon(Icons.cake),
              title: Text(DateFormat('dd-MMM-yyyy').format(student.dob).toString()),
              trailing: Text(student.boardName),
            ),
            Divider(color: Colors.black87,)
          ],
        ),
      ),
    );
  }

  Widget studentListWidget(){
    return ListView.builder(
      itemCount: _studentList.length,
      itemBuilder: (context, index){
        return GestureDetector(
            child: studentWidget(_studentList[index]),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => StudentProfile(studentModel: _studentList[index]),)).then((value) => getAllStudent());
            },
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllStudent();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RefreshIndicator(
        onRefresh: getAllStudent,
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            title: Text("Student List"),
            actions: [
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: (){
                  //TODO: Filter student details
                },
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.person_add),
            onPressed: (){
              //Add new student
              Navigator.push(context, MaterialPageRoute(builder:(context) => AddStudent(),)).then((value) => getAllStudent());
            },
          ),
          body: studentListWidget(),
        ),
      ),
    );
  }
}
