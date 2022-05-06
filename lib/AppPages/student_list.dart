import 'package:class_manager/AppPages/add_session_page.dart';
import 'package:class_manager/AppPages/add_student_page.dart';
import 'package:class_manager/AppPages/student_details.dart';
import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/complete_student_detail.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/readable_session_data.dart';
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

  List<CompleteStudentDetail> _studentList = [];
  List<CompleteStudentDetail> _searchedStudentList = [];
  bool _isSearching = false;

  _getStudentDetails() async{
    _studentList.clear();
    List<StudentModel> tempStudentList =await StudentHelper.instance.getAllStudent();

    for(int i=0;i<tempStudentList.length;++i){
      List<ReadableSessionData> _sessionList = await _getSessionByStudentId(tempStudentList[i].id!);
      setState(() {
        _studentList.add(
            CompleteStudentDetail(studentModel: tempStudentList[i], sessionList: _sessionList)
        );
      });

    }
  }

  Future<ReadableSessionData> convertToReadableFormat(SessionModel sessionModel)async{
    SubjectModel? subjectModel = await SubjectHelper.instance.getSubject(sessionModel.subjectId);

    return ReadableSessionData(
      subjectModel: subjectModel!,
      sessionSlot: sessionModel.sessionSlot,
      startTime: sessionModel.startTime,
      endTime: sessionModel.endTime,
    );
  }
  Future<List<ReadableSessionData>> _getSessionByStudentId(int studentId)async{
    List<SessionModel> sessionList =await SessionHelper.instance.getSession(studentId);
    List<ReadableSessionData> readableSessionList = [];

    if(sessionList.isEmpty){
      return [];
    }

    for(int i=0;i<sessionList.length;++i){
      readableSessionList.add(await convertToReadableFormat(sessionList[i]));
    }
    return readableSessionList;
  }

  List<ClassModel> _classList = [];
  String _selectedClass = '';
  List<SubjectModel> _subjectList = [];
  String _selectedSubject = '';
  List<BoardModel> _boardList = [];
  String _selectedBoard = '';

  _initializeSearchFilters()async{
    var tempClassList = await ClassHelper.instance.getAllClass();
    var tempSubjectList = await SubjectHelper.instance.getAllSubject();
    var tempBoardList = await BoardHelper.instance.getAllBoard();
    setState(() {
      _classList = tempClassList;
      _subjectList = tempSubjectList;
      _boardList = tempBoardList;
    });
  }
  _getSearchedResults() async{
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
  }

  Widget studentDetailWidget(int index){
    List<CompleteStudentDetail> dataList = !_isSearching?_studentList:_searchedStudentList;
    StudentModel _studentModel = dataList[index].studentModel;
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => StudentDetails(
              completeStudentDetail: dataList[index],
            ))).then((value){
          setState(() {
            _getStudentDetails();
          });
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
                title: Text(_studentModel.name),
                trailing: Text(_studentModel.classData.className),
              ),
              ListTile(
                leading: Icon(Icons.cake_rounded),
                title:  Text(DateFormat('dd-MMM-yyyy').format(_studentModel.dob).toString()),
                trailing: Text(_studentModel.boardData.boardName),
              ),
              const Divider(color: Colors.black87,),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataList[index].sessionList.length,
                itemBuilder: (context, sessionIndex){
                  ReadableSessionData _sessionData = dataList[index].sessionList[sessionIndex];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(_sessionData.subjectModel.subjectName),
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
                    _initializeSearchFilters();
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
        body: !_isSearching?ListView.builder(
        itemCount: _studentList.length,
        itemBuilder: (context, index) {
          return studentDetailWidget(index);
        })
            :studentSearchWidget(),
      ),
    );
  }
}