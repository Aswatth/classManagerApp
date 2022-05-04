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

  final List<CompleteStudentDetail> _studentList = [];
  final List<CompleteStudentDetail> _searchedStudentList = [];
  bool _isSearching = false;

  _getStudentDetails() async{
    List<StudentModel> tempStudentList =await StudentHelper.instance.getAllStudent();

    for(int i=0;i<tempStudentList.length;++i){
      List<SessionReadableData> _sessionList = await _getSessionByStudentId(tempStudentList[i].id!);
      setState(() {
        _studentList.add(
            CompleteStudentDetail(studentModel: tempStudentList[i], sessionList: _sessionList)
        );
      });

    }
  }

  Future<SessionReadableData> convertToReadableFormat(SessionModel sessionModel)async{
    ClassModel? classModel = await ClassHelper.instance.getClass(sessionModel.classId);
    BoardModel? boardModel = await BoardHelper.instance.getBoard(sessionModel.boardId);
    SubjectModel? subjectModel = await SubjectHelper.instance.getSubject(sessionModel.subjectId);

    return SessionReadableData(
      className: classModel!.className,
      boardName: boardModel!.boardName,
      subjectName: subjectModel!.subjectName,
      sessionSlot: sessionModel.sessionSlot,
      startTime: sessionModel.startTime,
      endTime: sessionModel.endTime,
    );
  }
  Future<List<SessionReadableData>> _getSessionByStudentId(int studentId)async{
    List<SessionModel> sessionList =await SessionHelper.instance.getSession(studentId);
    List<SessionReadableData> readableSessionList = [];

    if(sessionList.isEmpty){
      return [];
    }

    for(int i=0;i<sessionList.length;++i){
      readableSessionList.add(await convertToReadableFormat(sessionList[i]));
    }
    return readableSessionList;
  }

  void _showSessionDeletionPopup(int studentId, SessionReadableData sessionData) {
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

  List<ClassModel> _classList = [];
  String? _selectedClass;
  List<SubjectModel> _subjectList = [];
  String? _selectedSubject;
  List<BoardModel> _boardList = [];
  String? _selectedBoard;
  
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
    int selectedClassId = -1;
    int selectedSubjectId = -1;
    int selectedBoardId = -1;

    for (var element in _classList) {
      if(_selectedClass != null){
        if(element.className == _selectedClass){
          selectedClassId = element.id!;
        }
      }
    }

    for (var element in _subjectList) {
      if(_selectedSubject!=null){
        if(element.subjectName == _selectedSubject){
          selectedSubjectId = element.id!;
        }
      }
    }

    for (var element in _boardList) {
      if(_selectedBoard!=null){
        if(element.boardName == _selectedBoard){
          selectedBoardId = element.id!;
        }
      }
    }
    List<SessionModel> sessionList =await SessionHelper.instance.getSearchedSession(
        selectedBoardId: selectedBoardId,
        selectedClassId: selectedClassId,
        selectedSubjectId: selectedSubjectId
    );
    Map<int,CompleteStudentDetail> studentDictionary = <int,CompleteStudentDetail>{};

    for(int i=0;i<sessionList.length;++i){
      int studentId = sessionList[i].studentId;
      StudentModel? studentModel = await StudentHelper.instance.getStudent(studentId);

      if(studentModel != null){
        if(!studentDictionary.containsKey(studentId)){
          SessionReadableData sessionReadableData = await convertToReadableFormat(sessionList[i]);

          studentDictionary[studentId] = CompleteStudentDetail(studentModel: studentModel, sessionList: []);
          studentDictionary[studentId]!.addSession(sessionReadableData);
        }else{
          SessionReadableData sessionReadableData = await convertToReadableFormat(sessionList[i]);

          studentDictionary[studentId]!.addSession(sessionReadableData);
        }
      }
    }
    setState(() {
      _searchedStudentList.clear();
      studentDictionary.forEach((key, value) {
        _searchedStudentList.add(value);
      });
    });
  }

  Widget studentDetailWidget(int index){
    List<CompleteStudentDetail> dataList = !_isSearching?_studentList:_searchedStudentList;
    StudentModel _studentModel = dataList[index].studentModel;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_rounded),
                    title: Text(_studentModel.name),
                  ),
                  ListTile(
                    leading: Icon(Icons.cake_rounded),
                    title:  Text(DateFormat('dd-MMM-yyyy').format(_studentModel.dob).toString()),
                  ),
                  const Divider(color: Colors.black87,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dataList[index].sessionList.length,
                    itemBuilder: (context, sessionIndex){
                      SessionReadableData _sessionData = dataList[index].sessionList[sessionIndex];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: (){
                            //TODO: EDIT SESSION
                          },
                          onLongPress: (){
                            setState(() {
                              _showSessionDeletionPopup(_studentModel.id!, _sessionData);
                            });
                          },
                          title: Text(_sessionData.className +"\t"+_sessionData.subjectName),
                          subtitle: Text(_sessionData.boardName+"\n"+_sessionData.sessionSlot.replaceAll("[", "").replaceAll("]", "")),
                          trailing: Text(_sessionData.startTime+" - "+_sessionData.endTime),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.edit_rounded)
                  ),
                  IconButton(
                      onPressed: (){
                        setState(() {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => AddSession(studentId: dataList[index].studentModel.id!,studentName: dataList[index].studentModel.name)));
                        });
                      },
                      icon: Icon(Icons.more_time_rounded)
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.query_stats_rounded)
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.attach_money_rounded)
                  )
                ],
              ),
            )
          ],
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
                value: _selectedClass,
                hint: Text("Select class"),
                onChanged: (_){
                  setState(() {
                    _selectedClass = _ as String?;
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
                value: _selectedSubject,
                hint: Text("Select subject"),
                onChanged: (_){
                  setState(() {
                    _selectedSubject = _ as String?;
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
                value: _selectedBoard,
                hint: Text("Select board"),
                onChanged: (_){
                  setState(() {
                    _selectedBoard = _ as String?;
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
                    _selectedClass = null;
                    _selectedSubject = null;
                    _selectedBoard = null;
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
                    MaterialPageRoute(builder: (context) => AddStudent()));
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
class CompleteStudentDetail{
  StudentModel studentModel;
  List<SessionReadableData> sessionList;

  CompleteStudentDetail({
    required this.studentModel,
    required this.sessionList
  });
  addSession(SessionReadableData sessionData){
    sessionList.add(sessionData);
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