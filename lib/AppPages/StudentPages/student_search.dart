import 'dart:collection';

import 'package:class_manager/AppPages/StudentPages/student_profile.dart';
import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StudentSearch extends StatefulWidget {
  const StudentSearch({Key? key}) : super(key: key);

  @override
  _StudentSearchState createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {

  List<StudentModel> _studentList = [];

  List<ClassModel> _classList = [];
  List<BoardModel> _boardList = [];
  List<SubjectModel> _subjectList = [];

  String _selectedClassName = '';
  String _selectedBoardName = '';
  String _selectedSubject = '';

  bool isSearching = false;

  getAllClass()async{
    List<ClassModel> temp = await ClassHelper.instance.getAllClass();
    setState(() {
      _classList = temp;
    });
  }

  getAllBoard()async{
    List<BoardModel> temp = await BoardHelper.instance.getAllBoard();
    setState(() {
      _boardList = temp;
    });
  }

  getAllSubject() async{
    List<SubjectModel> _temp = await SubjectHelper.instance.getAllSubject();
    setState(() {
      _subjectList = _temp;
    });
  }

  Future<void> getAllStudent()async{
    List<StudentModel> temp = await StudentHelper.instance.getAllStudent();
    setState(() {
      _studentList = temp;
    });
  }

  Future<void> getSearchedStudent()async{
    if(_selectedClassName.isNotEmpty && _selectedBoardName.isNotEmpty){
      List<StudentModel> temp = await StudentHelper.instance.getStudentByClassAndBoard(_selectedClassName, _selectedBoardName);
      setState(() {
        _studentList = temp;
      });
    }
    else if(_selectedClassName.isNotEmpty){
      List<StudentModel> temp = await StudentHelper.instance.getStudentByClass(_selectedClassName);
      setState(() {
        _studentList = temp;
      });
    }
    else if(_selectedBoardName.isNotEmpty){
      List<StudentModel> temp = await StudentHelper.instance.getStudentByBoard(_selectedBoardName);
      setState(() {
        _studentList = temp;
      });
    }
    else{
      getAllStudent();
    }

    List<int> studentIdList = [];
    for(int i=0; i<_studentList.length;++i){
      studentIdList.add(_studentList[i].id!);
    }

    if(_selectedSubject.isNotEmpty){
      List<SessionModel> sessionList = await SessionHelper.instance.getSessionBySubject(_selectedSubject);
      List<int> sessionStudentId = [];
      for(int i=0; i<sessionList.length;++i){
        sessionStudentId.add(sessionList[i].studentId);
      }

      List<int> commonIdList = studentIdList.toSet().intersection(sessionStudentId.toSet()).toList();

      _studentList.removeWhere((element) => !commonIdList.contains(element.id!));

      print(_studentList.length);
    }
  }

  Future<List<SessionModel>> getSession(int studentId)async{
    if(_selectedSubject.isEmpty){
      List<SessionModel> temp = await SessionHelper.instance.getSessionByStudentId(studentId);

      return temp;
    }
    else{
      List<SessionModel> temp = await SessionHelper.instance.getSession(studentId,_selectedSubject);

      return temp;
    }
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

  Widget classDropDown(){
    return ListTile(
        leading: Icon(Icons.assignment),
        title: DropdownButtonFormField(
          hint: Text("Select class"),
          validator: (value){
            if(value == null){
              return 'Select class';
            }else{
              return null;
            }
          },
          items: _classList.map<DropdownMenuItem<String>>((ClassModel classModel){
            return DropdownMenuItem(
              value: classModel.className,
              child: Text(classModel.className),
            );
          }).toList(),
          value: _selectedClassName.isEmpty?null:_selectedClassName,
          onChanged: (_){
            setState(() {
              _selectedClassName = (_ as String?)!;
            });
          },
          onSaved: (_){
            setState(() {
              _selectedClassName = (_ as String?)!;
            });
          },
        )
    );
  }

  Widget boardDropDown(){
    return ListTile(
        leading: Icon(Icons.menu_book),
        title:DropdownButtonFormField(
          hint: Text("Select board"),
          validator: (value){
            if(value == null){
              return 'Select board';
            }else{
              return null;
            }
          },
          items: _boardList.map<DropdownMenuItem<String>>((BoardModel boardModel){
            return DropdownMenuItem(
              value: boardModel.boardName,
              child: Text(boardModel.boardName),
            );
          }).toList(),
          value: _selectedBoardName.isEmpty?null:_selectedBoardName,
          onChanged: (_){
            setState(() {
              _selectedBoardName = (_ as String?)!;
            });
          },
          onSaved: (_){
            setState(() {
              _selectedBoardName = (_ as String?)!;
            });
          },
        )
    );
  }

  Widget subjectDropDown(){
    return ListTile(
      leading: Icon(Icons.architecture),
      title: DropdownButtonFormField(
        hint: Text("Select subject"),
        validator: (value){
          if(value == null){
            return 'Select subject';
          }else{
            return null;
          }
        },
        items: _subjectList.map<DropdownMenuItem<String>>((SubjectModel subjectModel){
          return DropdownMenuItem(
            value: subjectModel.subjectName,
            child: Text(subjectModel.subjectName),
          );
        }).toList(),
        value: _selectedSubject.isEmpty?null:_selectedSubject,
        onChanged: (_){
          setState(() {
            _selectedSubject = _ as String;
          });
        },
        onSaved: (_){
          setState(() {
            _selectedSubject = _ as String;
          });
        },
      ),
    );
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
    getAllClass();
    getAllBoard();
    getAllSubject();
    getAllStudent();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RefreshIndicator(
        onRefresh: !isSearching?getAllStudent:getSearchedStudent,
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            title: Text("Search"),
          ),
          body: Column(
            children: [
              classDropDown(),
              boardDropDown(),
              subjectDropDown(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text("Search"),
                    onPressed: (){
                      setState(() {
                        isSearching = true;
                      });
                      getSearchedStudent();
                    },
                  ),
                  ElevatedButton(
                    child: Text("Clear"),
                    onPressed: (){
                      setState(() {
                        isSearching = false;

                        _selectedBoardName = '';
                        _selectedClassName = '';
                        _selectedSubject = '';

                        getAllStudent();
                      });
                    },
                  ),
                ],
              ),
              Expanded(child: studentListWidget())
            ],
          ),
        ),
      ),
    );
  }
}
