import 'package:class_manager/AppPages/add_student_page.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({Key? key}) : super(key: key);

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {

  List<StudentModel> studentList = [];
  List<List<SessionModel>> sessionList = [];

  @override
  void initState(){
    super.initState();
    _getStudentDetails();
  }

  Future<List<StudentModel>> _getStudentDetails() async{
    List<StudentModel> tempStudentModel =await StudentHelper.instance.getAllStudent();
    setState(() {
      studentList = tempStudentModel;
    });
    return studentList;
  }
  _getSession(int studentId)async{
    setState(() async{
      sessionList.add(await SessionHelper.instance.getSession(studentId));
    });
    //return sessionList;
  }
  /*void showPopUp(StudentModel student){
    Alert(
      context: context,
      content: Column(
        children: [
          ListTile(
            leading: Text("Name:"),
            title: TextField(
              controller: TextEditingController()..text = student.name,
              onChanged: (_){
                student.name = _;
              },
            ),
          ),
          ListTile(
            leading: Text("Name:"),
            title: TextField(
              controller: TextEditingController()..text = student.name,
              onChanged: (_){
                student.studentPhoneNumber = _;
              },
            ),
          ),
        ],
      )
    ).show();
  }*/
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
          title: Text("Student details"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.person_add_alt_1_rounded),
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddStudent())
            );
          },
        ),
        body: RefreshIndicator(
          onRefresh: _getStudentDetails,
          child: ListView.builder(
            itemCount: studentList.length,
            itemBuilder: (context,studentIndex){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name:\t"+studentList[studentIndex].name),
                        Text("DOB:\t"+DateFormat('dd-MMM-yyyy').format(studentList[studentIndex].dob).toString()),
                        Text("Location:\t"+studentList[studentIndex].location),
                        Text("Student Phn.Number:\t"+studentList[studentIndex].studentPhoneNumber),
                        Text("Parent Phn.Number 1:\t"+studentList[studentIndex].parentPhoneNumber1),
                        Text("Parent Phn.Number 2:\t"+studentList[studentIndex].parentPhoneNumber2!),
                        Container(
                            height: 200,
                            child:  ListView.builder(
                              itemCount: sessionList.length,
                              itemBuilder: (context,sessionIndex){
                                return Text(sessionList[sessionIndex].toString());
                              },
                            )
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
