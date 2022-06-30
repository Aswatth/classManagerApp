import 'package:class_manager/AppPages/StudentPages/student_home.dart';
import 'package:class_manager/Model/fee.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/student_session.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'add_student.dart';

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

  List<StudentSessionModel> _completeDataList = [];

  Future<void> getAllData()async{
    List<StudentSessionModel> temp = await StudentSessionHelper.instance.getAllData();

    setState(() {
      _completeDataList = temp;
    });
  }

  getStudent(int studentId)async{

    StudentModel? studentModel = await StudentHelper.instance.getStudent(studentId);

    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentHome(studentModel: studentModel!),)).then((value) => getAllData());
  }

  deleteStudent(int studentId)async{
    try {
      bool isSuccessful = await StudentHelper.instance.delete(studentId);

      if(isSuccessful){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Deleted successfully!"),
        ),);
        getAllData();
      }
    }
    catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Delete student session/fee details first."),
      ),);
    }
  }

  deleteConfirmation(int studentId, String studentName){
    Alert(
      context: context,
      content: Text("Are you sure you want to delete ${studentName}'s details"),
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
            deleteStudent(studentId);
            Navigator.pop(context);
          },
        )
      ]
    ).show();
  }

  Widget studentListWidget(){
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _completeDataList.length,
            itemBuilder: (context, index){
              StudentSessionModel completeData = _completeDataList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    getStudent(completeData.id);
                  },
                  onLongPress: (){
                    deleteConfirmation(completeData.id, completeData.name);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(completeData.name),
                          trailing: Text("${completeData.className} - ${completeData.boardName}"),
                        ),
                        Divider(color: Colors.black87,),
                        completeData.studentId != -1?
                        ListTile(
                          title: Text(completeData.subjectName!),
                          subtitle: Text(completeData.sessionSlot!.replaceAll("[", "").replaceAll("]", "")),
                          trailing: Text("${completeData.startTime!} - ${completeData.endTime!}"),
                        ):Container()
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getAllData,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Student List"),
          actions: [
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudent(),)).then((value) => getAllData());
              },
            )
          ],
        ),
        body: studentListWidget(),
      ),
    );
  }
}
