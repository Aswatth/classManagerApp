import 'package:class_manager/AppPages/add_session_page.dart';
import 'package:class_manager/AppPages/add_student_page.dart';
import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tuple/tuple.dart';

class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({Key? key}) : super(key: key);

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {

  //List<StudentModel> studentList = [];
  //List<Tuple5<String,String,String,String,String>> sessionList = [];

  @override
  void initState(){
    super.initState();
    _getStudentDetails();
  }

  Future<List<StudentModel>> _getStudentDetails() async{
    List<StudentModel> tempStudentList =await StudentHelper.instance.getAllStudent();
    return tempStudentList;
  }
  Future<List<SessionReadableData>> _getSessionByStudentId(int studentId)async{
    List<SessionModel> sessionList =await SessionHelper.instance.getSession(studentId);
    List<SessionReadableData> readableSessionList = [];

    if(sessionList.isEmpty){
      return readableSessionList;
    }

    for(int i=0;i<sessionList.length;++i){
      ClassModel? classModel = await ClassHelper.instance.getClass(sessionList[i].classId);
      BoardModel? boardModel = await BoardHelper.instance.getBoard(sessionList[i].boardId);
      SubjectModel? subjectModel = await SubjectHelper.instance.getSubject(sessionList[i].subjectId);

      setState(() {
        readableSessionList.add(
            SessionReadableData(
              className: classModel!.className,
              boardName: boardModel!.boardName,
              subjectName: subjectModel!.subjectName,
              sessionSlot: sessionList[i].sessionSlot,
              startTime: sessionList[i].startTime,
              endTime: sessionList[i].endTime,
            )
        );
      });
    }
    return readableSessionList;
  }

  void _showSessionPopup(int studentId, SessionReadableData sessionData)
  {
    int classId = -1;
    ClassHelper.instance.getClassId(sessionData.className).then((value) {
      classId = value!;
    });

    int boardId = -1;
    BoardHelper.instance.getBoardId(sessionData.boardName).then((value){
      boardId = value!;
    });

    int subjectId = -1;
    SubjectHelper.instance.getSubjectId(sessionData.subjectName).then((value){
      subjectId = value!;
    });

    Alert(
      context:context,
      content: Text("Are you sure you want to delete this session?"),
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
            //Delete session
            SessionHelper.instance.delete(studentId, classId, subjectId, boardId);
            Navigator.pop(context);
          },
        )
      ]
    ).show();
  }

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
          child: FutureBuilder<List<StudentModel>>(
            future: _getStudentDetails(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
              else{
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, studentIndex) {
                    StudentModel studentModel = snapshot.data![studentIndex];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.school_rounded),
                                  title: Text(studentModel.name),
                                ),
                                ListTile(
                                  leading: Icon(Icons.event),
                                  title: Text(DateFormat('dd-MMM-yyyy').format(studentModel.dob).toString()),
                                ),
                                ListTile(
                                  leading: Icon(Icons.call),
                                  title: Text(studentModel.studentPhoneNumber),
                                ),
                                Divider(
                                  color: Colors.black,
                                ),

                                FutureBuilder<List<SessionReadableData>>(
                                  future: _getSessionByStudentId(studentModel.id!),
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
                                    else{
                                      if(snapshot.data!.length == 0) return Container();
                                      else{
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            SessionReadableData session = snapshot.data![index];
                                            return ListTile(
                                              onTap: (){
                                                _showSessionPopup(studentModel.id!,session);
                                                setState(() {
                                                });
                                              },
                                              title: Text(session.className+"-"+session.subjectName),
                                              subtitle: Text(session.boardName+"\n"+session.sessionSlot.replaceAll("[", "").replaceAll("]", "")),
                                              trailing: Text(session.startTime+" - "+session.endTime),
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                ),
                                TextButton(
                                  child: Text("Add session"),
                                  onPressed: (){
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => AddSession(studentId: studentModel.id!,studentName: studentModel.name,))
                                    );
                                  },
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.edit),
                          ),
                        ),
                      ),
                    );
                  }
                );
              }
            },
          )
        ),
      ),
    );
  }
}

class SessionReadableData{
  String className;
  String subjectName;
  String boardName;
  String sessionSlot;
  String startTime;
  String endTime;

  SessionReadableData({
      required this.className,
      required this.subjectName, 
      required this.boardName,
      required this.sessionSlot, 
      required this.startTime, 
      required this.endTime});


}