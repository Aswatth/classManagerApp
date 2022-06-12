import 'package:class_manager/AppPages/add_session_page.dart';
import 'package:class_manager/AppPages/add_student_page.dart';
import 'package:class_manager/AppPages/student_details.dart';
import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({Key? key}) : super(key: key);

  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {

  @override
  void initState(){
    super.initState();
    _getStudentDetails();
    //_initializeSearchFilters();
  }
  bool _isSearching = false;

  List<CompleteStudentDetail> _studentList = [];

  _getStudentDetails()async {
    _studentList.clear();
    List<StudentModel> studentList = await StudentHelper.instance
        .getAllStudent();
    print("Student list: "+studentList.length.toString());
    for (int i = 0; i < studentList.length; ++i) {
      List<SessionModel> sessionList = await _getSession(studentList[i]);
      _studentList.add(CompleteStudentDetail(studentList[i], sessionList));
    }

    setState(() {
    });
  }

  List<ClassModel> _classList = [];
  String _selectedClass = '';
  List<SubjectModel> _subjectList = [];
  String _selectedSubject = '';
  List<BoardModel> _boardList = [];
  String _selectedBoard = '';

  /*_initializeSearchFilters()async{
    var tempClassList = await ClassHelper.instance.getAllClass();
    var tempSubjectList = await SubjectHelper.instance.getAllSubject();
    var tempBoardList = await BoardHelper.instance.getAllBoard();
    setState(() {
      _classList = tempClassList;
      _subjectList = tempSubjectList;
      _boardList = tempBoardList;
    });
  }*/
  /*_getSearchedResults() async{
    _searchedStudentList.clear();
    print("$_selectedClass - $_selectedBoard - $_selectedSubject ");

    setState(() {
      if(_selectedClass.isNotEmpty && _selectedBoard.isNotEmpty) {
        for (var element in _studentList) {
          if (element.studentModel.classData.className == _selectedClass &&
              element.studentModel.boardData.boardName == _selectedBoard) {
            _searchedStudentList.add(element);
          }
        }
      }
      else{
        if (_selectedClass.isNotEmpty){
          for(var element in _studentList) {
            if (element.studentModel.classData.className == _selectedClass) {
              _searchedStudentList.add(element);
            }
          }
        }
        if (_selectedBoard.isNotEmpty){
          for(var element in _studentList) {
            if (element.studentModel.boardData.boardName == _selectedBoard) {
              _searchedStudentList.add(element);
            }
          }
        }
      }
      if(_selectedSubject.isNotEmpty){
        if (_selectedClass.isNotEmpty || _selectedBoard.isNotEmpty){
          List<CompleteStudentDetail> temp = [];
          for(var element in _searchedStudentList){
            for(var session in element.sessionList){
              if(session.subjectModel.subjectName == _selectedSubject){
                temp.add(element);
              }
            }
          }
          _searchedStudentList = temp;
        }
        else{
          for(var element in _studentList){
            for(var session in element.sessionList){
              if(session.subjectModel.subjectName == _selectedSubject){
                _searchedStudentList.add(element);
              }
            }
          }
        }
      }

      if(_selectedSubject.isEmpty && _selectedBoard.isEmpty && _selectedClass.isEmpty){
        _searchedStudentList = _studentList;
      }

      _searchedStudentList = _searchedStudentList.toSet().toList();
    });
  }*/

  Future<List<SessionModel>> _getSession(StudentModel student) async{
      return await SessionHelper.instance.getSession(student);
  }
  Widget studentDetailWidget(int index){
    CompleteStudentDetail _completeStudentDetail = _studentList[index];
    //print("Session Length "+sessionList.length.toString());
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => StudentDetails(studentModel: _completeStudentDetail.studentModel,))).then((value){
          _getStudentDetails();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: Icon(Icons.person_rounded),
                title: Text(_completeStudentDetail.studentModel.name),
                trailing: Text(_completeStudentDetail.studentModel.classData.className),
              ),
              ListTile(
                leading: Icon(Icons.cake_rounded),
                title:  Text(DateFormat('dd-MMM-yyyy').format(_completeStudentDetail.studentModel.dob).toString()),
                trailing: Text(_completeStudentDetail.studentModel.boardData.boardName),
              ),
              const Divider(color: Colors.black87,),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _completeStudentDetail.sessionList.length,
                itemBuilder: (context, sessionIndex){
                  SessionModel _sessionData = _completeStudentDetail.sessionList[sessionIndex];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(_sessionData.subjectData.subjectName),
                      subtitle: Text(_sessionData.sessionSlot.replaceAll("[", "").replaceAll("]", "")),
                      trailing: Text(_sessionData.startTime+" - "+_sessionData.endTime),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  /*Widget studentSearchWidget(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                items: _classList.map<DropdownMenuItem<String>>((_classModelItem){
                  return DropdownMenuItem(
                    value: _classModelItem.className,
                    child: Text(_classModelItem.className),
                  );
                }).toList(),
                value: _selectedClass.isEmpty?null:_selectedClass,
                hint: Text("Select class"),
                onChanged: (_){
                  setState(() {
                    _selectedClass = (_ as String);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                items: _subjectList.map<DropdownMenuItem<String>>((_subjectItem){
                  return DropdownMenuItem(
                    value: _subjectItem.subjectName,
                    child: Text(_subjectItem.subjectName),
                  );
                }).toList(),
                value: _selectedSubject.isEmpty?null:_selectedSubject,
                hint: Text("Select subject"),
                onChanged: (_){
                  setState(() {
                    _selectedSubject = (_ as String);
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                items: _boardList.map<DropdownMenuItem<String>>((_boardItem){
                  return DropdownMenuItem(
                    value: _boardItem.boardName,
                    child: Text(_boardItem.boardName),
                  );
                }).toList(),
                value: _selectedBoard.isEmpty?null:_selectedBoard,
                hint: Text("Select board"),
                onChanged: (_){
                  setState(() {
                    _selectedBoard = (_ as String);
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: (){
                  setState(() {
                    _getSearchedResults();
                  });
                },
                child: Text("Search",)
            ),
            TextButton(
                onPressed: (){
                  setState(() {
                    _selectedClass = '';
                    _selectedSubject = '';
                    _selectedBoard = '';
                    _searchedStudentList.clear();
                  });
                },
                child: Text(
                  "Clear filters",
                  style: TextStyle(
                      color: Colors.red
                  ),
                )
            ),
          ],
        ),
        Divider(color: Colors.black87,),
        Expanded(
          child: _searchedStudentList.isNotEmpty? ListView.builder(
              itemCount: _searchedStudentList.length,
              itemBuilder: (context, index) {
                return studentDetailWidget(index);
              }):Container(
            child: Center(
              child: Text("No records found"),
            ),
          ),
        )
      ],
    );
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
          actions: [
            IconButton(
              icon: Icon(Icons.person_add_alt_1_rounded),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddStudent())).then((value){
                      setState(() {
                        _getStudentDetails();
                      });
                });
              },
            ),
            IconButton(
              icon: !_isSearching?Icon(Icons.search_rounded):Icon(Icons.close_rounded),
              onPressed:  (){
              /*setState(() {
                _isSearching = !_isSearching;
                if(_isSearching){
                  //_getSearchedResults();
                }
              });*/
              }
            )
          ],
        ),
        body: ListView.builder(
          itemCount: _studentList.length,
          itemBuilder: (context, index) {
            return studentDetailWidget(index);
          })
        /* !_isSearching?
            :studentSearchWidget(),*/
      ),
    );
  }
}
class CompleteStudentDetail{
  late StudentModel studentModel;
  late List<SessionModel> sessionList;

  CompleteStudentDetail(StudentModel _studentModel, List<SessionModel> _sessionList)
  {
    this.studentModel = _studentModel;
    this.sessionList = _sessionList;
  }
}
/*
*/
