import 'package:class_manager/AppPages/add_session_page.dart';
import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/complete_student_detail.dart';
import 'package:class_manager/Model/readable_session_data.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StudentDetails extends StatefulWidget {
  final CompleteStudentDetail completeStudentDetail;
  const StudentDetails({Key? key,required this.completeStudentDetail}) : super(key: key);

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  bool _isEditing = false;

  String _name = '';
  String _schoolName = '';
  String _studentPhoneNumber = '';
  String _parentPhoneNumber1 = '';
  String _parentPhoneNumber2 = '';
  late DateTime _dob;
  String _location = '';

  List<ClassModel> _classList = [];
  String? _selectedClass = null;

  List<BoardModel> _boardList = [];
  String? _selectedBoard = null;

  _getAllClass() {
    setState(() {
      ClassHelper.instance.getAllClass().then((value){
        setState(() {
          _classList = value;
        });
      });
    });
  }
  _getAllBoard() async{
    setState(() {
      BoardHelper.instance.getAllBoard().then((value){
        setState(() {
          _boardList = value;
        });
      });
    });
  }

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dobController;
  late final TextEditingController _schoolNameController;
  late final TextEditingController _studentPhnNumController;
  late final TextEditingController _parentPhnNum1Controller;
  late final TextEditingController _parentPhnNum2Controller;
  late final TextEditingController _locationController;

  Widget nameField() {
    return TextFormField(
      enabled: _isEditing,
      controller: _nameController,
      decoration: InputDecoration(
          icon: Icon(Icons.person),
          labelText: "Student name"
      ),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      validator: (value){
        if(value!.isEmpty){
          return 'Student name cannot be empty';
        }else{
          return null;
        }
      },
      onSaved: (value){
        setState(() {
          _name = value!;
        });
      },
    );
  }
  Widget dobField() {
    return DateTimePicker(
      enabled: _isEditing,
      //initialValue: widget.completeStudentDetail.studentModel.dob.toString(),
      controller: _dobController,
      type: DateTimePickerType.date,
      dateMask: 'dd-MMM-yyyy',
      decoration: InputDecoration(
        icon: Icon(Icons.event),
        labelText: "Student DOB",
      ),
      validator: (value){
        if(value!.isEmpty){
          return 'Student DOB cannot be empty';
        }else{
          return null;
        }
      },
      firstDate: DateTime(1999),
      lastDate: DateTime(2100),
      onSaved: (value){
        setState(() {
          _dob = DateTime.parse(value!);
        });
      },
    );
  }
  Widget schoolNameField() {
    return TextFormField(
      enabled: _isEditing,
      controller: _schoolNameController,
      decoration: InputDecoration(
          icon: Icon(Icons.school_rounded),
          labelText: "School name"
      ),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      validator: (value){
        if(value!.isEmpty){
          return 'School name cannot be empty';
        }else{
          return null;
        }
      },
      onSaved: (value){
        setState(() {
          _schoolName = value!;
        });
      },
    );
  }
  Widget classDropDown(){
    return ListTile(
        leading: Icon(Icons.book_rounded),
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
          value: _selectedClass,
          onChanged: _isEditing?(_){
            setState(() {
              _selectedClass = _ as String?;
            });
          }:null,
          onSaved: (_){
            setState(() {
              _selectedClass = _ as String?;
            });
          },
        )
    );
  }
  Widget boardDropDown(){
    return ListTile(
        leading: Icon(Icons.assignment_rounded),
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
          value: _selectedBoard,
          onChanged: _isEditing?(_){
            setState(() {
              _selectedBoard = _ as String?;
            });
          }:null,
          onSaved: (_){
            setState(() {
              _selectedBoard = _ as String?;
            });
          },
        )
    );
  }
  Widget studentPhoneNumberField() {
    return TextFormField(
      enabled: _isEditing,
      controller: _studentPhnNumController,
      decoration: InputDecoration(
        icon: Icon(Icons.call),
        labelText: "Student phone number",
      ),
      keyboardType: TextInputType.number,
      maxLength: 10,
      validator: (value){
        if(value!.isEmpty || value.length < 10){
          return 'Invalid Student number';
        }else{
          return null;
        }
      },
      onSaved: (value){
        setState(() {
          _studentPhoneNumber = value!;
        });
      },
    );
  }
  Widget parentPhoneNumber1Field(){
    return TextFormField(
      enabled: _isEditing,
      controller: _parentPhnNum1Controller,
      decoration: InputDecoration(
        icon: Icon(Icons.call),
        labelText: "Parent phone number 1",
      ),
      keyboardType: TextInputType.number,
      maxLength: 10,
      validator: (value){
        if(value!.isEmpty || value.length < 10){
          return 'Invalid Parent number';
        }else{
          return null;
        }
      },
      onSaved: (value){
        setState(() {
          _parentPhoneNumber1 = value!;
        });
      },
    );
  }
  Widget parentPhoneNumber2Field(){
    return TextFormField(
      enabled: _isEditing,
      controller: _parentPhnNum2Controller,
      decoration: InputDecoration(
        icon: Icon(Icons.call),
        labelText: "Parent phone number 2",
      ),
      keyboardType: TextInputType.number,
      maxLength: 10,
      validator: (value){
        if(value!.isNotEmpty && value.length < 10) {
          return 'Invalid Parent phone number';
        } else {
          return null;
        }
      },
      onSaved: (value){
        setState(() {
          _parentPhoneNumber2 = value!;
        });
      },
    );
  }
  Widget locationField() {
    return TextFormField(
      enabled: _isEditing,
      controller: _locationController,
      decoration: InputDecoration(
          icon: Icon(Icons.location_on_rounded),
          labelText: "Location"
      ),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      validator: (value){
        if(value!.isEmpty){
          return 'Location cannot be empty';
        }else{
          return null;
        }
      },
      onSaved: (value){
        setState(() {
          _location = value!;
        });
      },
    );
  }

  _save(){
    print("SAVING");
    _formKey.currentState!.save();

    late ClassModel _selectedClassModel;
    late BoardModel _selectedBoardModel;

    for(int i =0;i<_classList.length;++i){
      if(_classList[i].className == _selectedClass){
        _selectedClassModel =_classList[i];
        break;
      }
    }
    for(int i =0;i<_boardList.length;++i){
      if(_boardList[i].boardName == _selectedBoard){
        _selectedBoardModel =_boardList[i];
        break;
      }
    }

    StudentModel student = widget.completeStudentDetail.studentModel;

    student.studentPhoneNumber = _studentPhoneNumber;
    student.parentPhoneNumber1 = _parentPhoneNumber1;
    student.parentPhoneNumber2 = _parentPhoneNumber2;
    student.name = _name;
    student.schoolName = _schoolName;
    student.dob = _dob;
    student.location = _location;
    student.classData = _selectedClassModel;
    student.boardData = _selectedBoardModel;

    setState(() {
      StudentHelper.instance.update(student);
      widget.completeStudentDetail.studentModel = student;
    });
  }

  Widget studentDrawer() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(color: Colors.black87,),
          ListTile(
            onTap: (){
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      AddSession(studentId: widget.completeStudentDetail.studentModel.id!,studentName: widget.completeStudentDetail.studentModel.name)))
              .then((value){
                setState(() {
                  _getSession();
                });
              });*/
              sessionPopUp();
            },
            leading: Icon(Icons.more_time_rounded),
            title: Text("Add session"),
          ),
          ListTile(
            leading: Icon(Icons.query_stats_rounded),
            title: Text("Performance"),
          ),
          ListTile(
            leading: Icon(Icons.attach_money_rounded),
            title: Text("Fees"),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_rounded),
            title: Text("Delete student"),
          ),
          Divider(color: Colors.black87,),
          ListTile(
            title: Text("Session list"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.completeStudentDetail.sessionList.length,
                  itemBuilder: (context, sessionIndex){
                    ReadableSessionData _sessionData = widget.completeStudentDetail.sessionList[sessionIndex];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: (){
                          sessionPopUp(_sessionData);
                        },
                        onLongPress: (){
                          setState(() {
                            _showSessionDeletionPopup(widget.completeStudentDetail.studentModel.id!, _sessionData);
                          });
                        },
                        title: Text(_sessionData.subjectModel.subjectName),
                        subtitle: Text(_sessionData.sessionSlot.replaceAll("[", "").replaceAll("]", "")),
                        trailing: Text(_sessionData.startTime+" - "+_sessionData.endTime),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void sessionPopUp([ReadableSessionData? sessionData]){
    Alert(
      context: context,
      content: _isEditing?AddSession(studentId: widget.completeStudentDetail.studentModel.id!,sessionData: sessionData,)
          :AddSession(studentId: widget.completeStudentDetail.studentModel.id!),
    ).show().then((value){
      _getSession();
    });
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
  _getSession()async{
    List<SessionModel> sessionList = await SessionHelper.instance.getSession(widget.completeStudentDetail.studentModel.id!);

    List<ReadableSessionData> readableSessionList = [];

    for(int i=0;i<sessionList.length;++i){
      convertToReadableFormat(sessionList[i]).then((value) => readableSessionList.add(value));
    }
    setState(() {
      widget.completeStudentDetail.sessionList = readableSessionList;
    });
  }

  void _showSessionDeletionPopup(int studentId, ReadableSessionData sessionData) {
    int subjectId = sessionData.subjectModel.id==null?-1:sessionData.subjectModel.id!;
    print("DELETING: $studentId, $subjectId");
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
              SessionHelper.instance.delete(studentId, subjectId);
              setState(() {
                _getSession();
                Navigator.pop(context);
              });
            },
          )
        ]
    ).show();
  }

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.completeStudentDetail.studentModel.name);
    _dobController = TextEditingController(text: widget.completeStudentDetail.studentModel.dob.toString());
    _schoolNameController = TextEditingController(text: widget.completeStudentDetail.studentModel.schoolName);
    _studentPhnNumController = TextEditingController(text: widget.completeStudentDetail.studentModel.studentPhoneNumber);
    _parentPhnNum1Controller = TextEditingController(text: widget.completeStudentDetail.studentModel.parentPhoneNumber1);
    _parentPhnNum2Controller = TextEditingController(text: widget.completeStudentDetail.studentModel.parentPhoneNumber2);
    _locationController = TextEditingController(text: widget.completeStudentDetail.studentModel.location);

    _getAllClass();
    _selectedClass = widget.completeStudentDetail.studentModel.classData.className;
    _getAllBoard();
    _selectedBoard = widget.completeStudentDetail.studentModel.boardData.boardName;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: studentDrawer(),
        appBar: AppBar(
          leading: BackButton(
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text("Student Details"),
        ),
        floatingActionButton: FloatingActionButton(
          child: !_isEditing? Icon(Icons.edit_rounded):Icon(Icons.clear),
          onPressed: (){
            setState(() {
              _isEditing = !_isEditing;
            });
          },
        ),
        body:Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                nameField(),
                dobField(),
                schoolNameField(),
                classDropDown(),
                boardDropDown(),
                studentPhoneNumberField(),
                parentPhoneNumber1Field(),
                parentPhoneNumber2Field(),
                locationField(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    onPressed: (){
                      setState(() {
                        //Save
                        if(_formKey.currentState!.validate()){
                          _save();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: ListTile(
                              title: Text("Saved student information"),
                              trailing: Icon(Icons.done_outline_rounded),
                            ),
                          ));
                        }
                      });
                    },
                    child: Text("Save"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

