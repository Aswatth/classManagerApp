import 'package:class_manager/AppPages/StudentPages/student_profile.dart';
import 'package:class_manager/AppPages/StudentPages/student_search.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'add_student.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

  List<StudentModel> _studentList = [];

  List<SessionModel> _sessionList = [];

  Future<void> getAllStudent()async{
    List<StudentModel> temp = await StudentHelper.instance.getAllStudent();
    setState(() {
      _studentList = temp;
    });
  }

  Future<List<SessionModel>> getSession(int studentId)async{
    List<SessionModel> temp = await SessionHelper.instance.getSessionByStudentId(studentId);

    return temp;
    /*setState(() {
      _sessionList = temp;
    });*/
  }

  deleteStudent(StudentModel student)async{
    await StudentHelper.instance.delete(student);

    getAllStudent();
  }

  deleteConfirmation(StudentModel student){
    Alert(
      context: context,
      content: Text("Are you sure you want to delete ${student.name}'s details"),
      buttons: [
        DialogButton(
          child: Text("No"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text("Yes"),
          onPressed: (){
            deleteStudent(student);
            Navigator.pop(context);
          },
        )
      ]
    ).show();
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
            Divider(color: Colors.black87,),
            FutureBuilder<List<SessionModel>>(
              future: getSession(student.id!),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index){
                      SessionModel session = snapshot.data![index];
                      return ListTile(
                        title: Text(session.subjectName),
                        subtitle: Text(session.sessionSlot.replaceAll("[", "").replaceAll("]", "")),
                        trailing: Text(session.startTime + " - " + session.endTime),
                      );
                    },
                  );
                }
                else{
                  return Container();
                }
              },
            )
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => StudentProfile(studentModel: _studentList[index]),)).then((value){
                setState(() {
                  getAllStudent();
                });
              });
            },
          onLongPress: (){
              setState(() {
                deleteConfirmation(_studentList[index]);
              });
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
                icon: Icon(Icons.search),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StudentSearch(),));
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
