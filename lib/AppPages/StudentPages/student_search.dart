import 'dart:collection';

import 'package:class_manager/AppPages/StudentPages/student_home.dart';
import 'package:class_manager/AppPages/StudentPages/student_profile.dart';
import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/student_session.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StudentSearch extends StatefulWidget {
  const StudentSearch({Key? key}) : super(key: key);

  @override
  _StudentSearchState createState() => _StudentSearchState();
}

class _StudentSearchState extends State<StudentSearch> {

  List<StudentSessionModel> _completeDataList = [];

  Future<void> getAllData()async{
    List<StudentSessionModel> temp = await StudentSessionHelper.instance.getAllData();

    setState(() {
      _completeDataList = temp;
    });
  }

  List<ClassModel> _classList = [];
  List<BoardModel> _boardList = [];
  List<SubjectModel> _subjectList = [];

  String _selectedClassName = '';
  String _selectedBoardName = '';
  String _selectedSubject = '';

  String _searchedStudentName = '';
  TextEditingController _controller = TextEditingController();

  String _startTime = '';
  String _endTime = '';
  TextEditingController _sessionStartTimeController = TextEditingController();
  TextEditingController _sessionEndTimeController = TextEditingController();

  bool isSearching = false;

  bool isExpanded = false;

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

  Future<void> getSearchedStudent()async {
    await getAllData();
    if(_selectedClassName.isNotEmpty){
      _completeDataList.removeWhere((element) => element.className != _selectedClassName);
    }
    if(_selectedBoardName.isNotEmpty){
      _completeDataList.removeWhere((element) => element.boardName != _selectedBoardName);
    }
    if(_selectedSubject.isNotEmpty){
      _completeDataList.removeWhere((element) => element.subjectName != null?element.subjectName! != _selectedSubject:true);
    }
    if(_startTime.isNotEmpty){
      DateTime startTime = DateFormat("hh:mm").parse(_startTime);

      _completeDataList.removeWhere((element){
        if(element.studentId != -1){
          DateTime sessionStartTime = DateFormat("hh:mm").parse(element.startTime!);
          return sessionStartTime.isBefore(startTime);
        }
        return false;
      });
    }
    if(_endTime.isNotEmpty){
      DateTime endTime = DateFormat("hh:mm").parse(_endTime);

      _completeDataList.removeWhere((element){
        if(element.studentId != -1){
          DateTime sessionEndTime = DateFormat("hh:mm").parse(element.endTime!);
          return sessionEndTime.isAfter(endTime);
        }
        return false;
      });
    }

    _completeDataList = List.from(_completeDataList.where((element){
      return element.name.toLowerCase().contains(_controller.text.toLowerCase());
    }).toList());
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

  Widget studentNameSearchFiled(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Student name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blueAccent)
          )
        ),
        onChanged: (_){
          setState(() {
            _searchedStudentName = _;
          });
        },
      ),
    );
  }

  Widget startTimeField() {
    return DateTimePicker(
      controller: _sessionStartTimeController,
      type: DateTimePickerType.time,
      locale: Locale('en', 'US'),
      use24HourFormat: true,
      decoration: InputDecoration(
        icon: Icon(Icons.access_time_rounded),
        labelText: "Session start time",
      ),
      validator: (value){
        if(value!.isEmpty){
          return 'Session start time cannot be empty';
        }else{
          return null;
        }
      },
      firstDate: DateTime(1999),
      lastDate: DateTime(2100),
      onChanged: (value){
        setState(() {
          _startTime = DateFormat.jm().format(DateFormat("hh:mm").parse(value));
        });
      },
    );
  }

  Widget endTimeField() {
    return DateTimePicker(
      controller: _sessionEndTimeController,
      type: DateTimePickerType.time,
      locale: Locale('en', 'US'),
      use24HourFormat: true,
      decoration: InputDecoration(
        icon: Icon(Icons.access_time_rounded),
        labelText: "Session end time",
      ),
      validator: (value){
        if(value!.isEmpty){
          return 'Session end time cannot be empty';
        }else{
          return null;
        }
      },
      firstDate: DateTime(1999),
      lastDate: DateTime(2100),
      onChanged: (value){
        setState(() {
          _endTime = DateFormat.jm().format(DateFormat("hh:mm").parse(value));
        });
      },
    );
  }

  Widget studentListWidget(){
    return ListView.builder(
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
    );
  }

  getStudent(int studentId)async{

    StudentModel? studentModel = await StudentHelper.instance.getStudent(studentId);

    Navigator.push(context, MaterialPageRoute(builder: (context) => StudentHome(studentModel: studentModel!),)).then((value) => getAllData());
  }

  search(){
    isSearching = true;

    getSearchedStudent();

    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  clearFilters(){
    isSearching = false;

    _selectedBoardName = '';
    _selectedClassName = '';
    _selectedSubject = '';
    _controller.clear();
    _sessionStartTimeController.clear();
    _sessionEndTimeController.clear();
    _searchedStudentName = _controller.text;

    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    getAllData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllData();
    getAllClass();
    getAllBoard();
    getAllSubject();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: !isSearching?getAllData:getSearchedStudent,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              title: Text("Search"),
            )
          ],
          body: Column(
            children: [
              ExpansionPanelList(
                expansionCallback: (id,_){
                  setState(() {
                    isExpanded = !_;
                  });
                },
                children: [
                  ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Text("Search by"),
                        );
                      },
                      isExpanded: isExpanded,
                      body: Column(
                        children: [
                          classDropDown(),
                          boardDropDown(),
                          subjectDropDown(),
                          studentNameSearchFiled(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: startTimeField(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: endTimeField(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  child: Text("Search"),
                                  onPressed: (){
                                    setState(() {
                                      search();
                                    });
                                  },
                                ),
                                ElevatedButton(
                                  child: Text("Clear"),
                                  onPressed: (){
                                    setState(() {
                                      clearFilters();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
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

