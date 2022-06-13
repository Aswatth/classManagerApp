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
    _initializeSearchFilters();
  }
  bool _isSearching = false;

  List<CompleteStudentDetail> _completeStudentDataList = [];

  List<CompleteStudentDetail> _searchedStudentList = [];

  _getStudentDetails()async {
    _completeStudentDataList.clear();
    List<StudentModel> studentList = await StudentHelper.instance
        .getAllStudent();
    print("Student list: "+studentList.length.toString());
    for (int i = 0; i < studentList.length; ++i) {
      List<SessionModel> sessionList = await _getSession(studentList[i]);
      _completeStudentDataList.add(CompleteStudentDetail(studentList[i], sessionList));
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

  _initializeSearchFilters()async{
    _classList = await ClassHelper.instance.getAllClass();
    _subjectList = await SubjectHelper.instance.getAllSubject();
    _boardList = await BoardHelper.instance.getAllBoard();

    setState(() {
    });
  }

  _getSearchedResults() async{
    _searchedStudentList.clear();
    print("Search filter: $_selectedClass - $_selectedBoard - $_selectedSubject ");

    if(_selectedClass.isEmpty && _selectedSubject.isEmpty && _selectedBoard.isEmpty){
      _searchedStudentList = List.from(_completeStudentDataList);
    }
    else if(_selectedBoard.isNotEmpty && _selectedClass.isNotEmpty){//When both BOARD and CLASS is selected
      for(int i = 0; i < _completeStudentDataList.length; ++i) {
        if(_completeStudentDataList[i].studentModel.classData.className == _selectedClass
            && _completeStudentDataList[i].studentModel.boardData.boardName == _selectedBoard){
          _searchedStudentList.add(_completeStudentDataList[i]);
        }
      }
    }
    else if(_selectedSubject.isNotEmpty && _selectedClass.isNotEmpty) {//When both SUBJECT and CLASS is selected
      for(int i = 0; i < _completeStudentDataList.length; ++i){
        for(int j=0; j < _completeStudentDataList[i].sessionList.length; ++j) {
          if(_completeStudentDataList[i].sessionList[j].subjectData.subjectName == _selectedSubject
              && _completeStudentDataList[i].studentModel.classData.className == _selectedClass){
            _searchedStudentList.add(_completeStudentDataList[i]);
            break;
          }
        }
      }
    }
    else if(_selectedSubject.isNotEmpty && _selectedBoard.isNotEmpty) {//When both SUBJECT and BOARD is selected
      for(int i = 0; i < _completeStudentDataList.length; ++i){
        for(int j=0; j < _completeStudentDataList[i].sessionList.length; ++j) {
          if(_completeStudentDataList[i].sessionList[j].subjectData.subjectName == _selectedSubject
              && _completeStudentDataList[i].studentModel.boardData.boardName == _selectedBoard){
            _searchedStudentList.add(_completeStudentDataList[i]);
            break;
          }
        }
      }
    }
    else if(_selectedSubject.isNotEmpty && _selectedBoard.isNotEmpty && _selectedClass.isNotEmpty){//When all three are selected
      for(int i = 0; i < _completeStudentDataList.length; ++i){
        for(int j=0; j < _completeStudentDataList[i].sessionList.length; ++j) {
          if(_completeStudentDataList[i].sessionList[j].subjectData.subjectName == _selectedSubject
              && _completeStudentDataList[i].studentModel.boardData.boardName == _selectedBoard
              && _completeStudentDataList[i].studentModel.classData.className == _selectedClass){
            _searchedStudentList.add(_completeStudentDataList[i]);
            break;
          }
        }
      }
    }
    else{
      for(int i = 0; i < _completeStudentDataList.length; ++i) {
        if(_selectedClass.isNotEmpty && _completeStudentDataList[i].studentModel.classData.className == _selectedClass){
          _searchedStudentList.add(_completeStudentDataList[i]);
        }
        else if(_selectedBoard.isNotEmpty && _completeStudentDataList[i].studentModel.boardData.boardName == _selectedBoard){
          print(_completeStudentDataList[i].studentModel.toString());
          _searchedStudentList.add(_completeStudentDataList[i]);
        }
        else if(_selectedSubject.isNotEmpty){
          for(int j=0; j < _completeStudentDataList[i].sessionList.length; ++j) {
            if(_completeStudentDataList[i].sessionList[j].subjectData.subjectName == _selectedSubject){
              _searchedStudentList.add(_completeStudentDataList[i]);
              break;
            }
          }
        }
      }
    }

    _searchedStudentList = _searchedStudentList.toSet().toList();

    setState(() {
    });
  }

  Future<List<SessionModel>> _getSession(StudentModel student) async{
      return await SessionHelper.instance.getSession(student);
  }

  Widget studentDetailWidget(CompleteStudentDetail _completeStudentDetail){

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

  Widget studentSearchWidget(){
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
                    _getSearchedResults();
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
                return studentDetailWidget(_searchedStudentList[index]);
              }):Container(
            child: Center(
              child: Text("No records found"),
            ),
          ),
        )
      ],
    );
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
              setState(() {
                _isSearching = !_isSearching;
                if(_isSearching){
                  _getSearchedResults();
                }
              });
              }
            )
          ],
        ),
        body:!_isSearching? ListView.builder(
          itemCount: _completeStudentDataList.length,
          itemBuilder: (context, index) {
            return studentDetailWidget(_completeStudentDataList[index]);
          })
            :studentSearchWidget(),
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
