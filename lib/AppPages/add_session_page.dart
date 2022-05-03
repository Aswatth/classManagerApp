import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddSession extends StatefulWidget {
  final int studentId;
  final String studentName;
  const AddSession({Key? key,required this.studentId,required this.studentName}) : super(key: key);

  @override
  _AddSessionState createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {

  final _formKey = GlobalKey<FormState>();
  final _multiSelectKey = GlobalKey<FormFieldState>();

  //Session details
  List<String> _classNames = [];
  String? _selectedClass = null;

  List<String> _boardNames = [];
  String? _selectedBoard = null;

  List<String> _subjectNames = [];
  String? _selectedSubject = null;
  List<String> sessionDays = ["Weekday","Weekend","Mon","Tue","Wed","Thur","Fri","Sat","Sun"];
  List<String> _selectedSessionDays = [];
  String _startTime = '';
  String _endTime = '';
  double _fees = 0.0;

  final TextEditingController _sessionStartTimeController = TextEditingController();
  final TextEditingController _sessionEndTimeController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();


  Future<List<String>> _getAllClass() async{
    List<ClassModel> _classList = await ClassHelper.instance.getAllClass();
    for(int i = 0; i < _classList.length; ++i){
      _classNames.add(_classList[i].className);
    }
    _classNames = _classNames.toSet().toList();
    return _classNames;
  }
  Future<List<String>> _getAllBoard() async{
    List<BoardModel> _boardList = await BoardHelper.instance.getAllBoard();
    for(int i = 0; i < _boardList.length; ++i){
      _boardNames.add(_boardList[i].boardName);
    }
    _boardNames = _boardNames.toSet().toList();//Remove duplicates
    return _boardNames;
  }
  Future<List<String>> _getAllSubject() async{
    List<SubjectModel> _subjectList = await SubjectHelper.instance.getAllSubject();
    for(int i = 0; i < _subjectList.length; ++i){
      _subjectNames.add(_subjectList[i].subjectName);
    }
    _subjectNames = _subjectNames.toSet().toList();//Remove duplicates
    return _subjectNames;
  }

  //Session details
  Widget classDropDown(){
    return ListTile(
      leading: Icon(Icons.book_rounded),
      title: FutureBuilder(
        future: _getAllClass(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return CircularProgressIndicator();
          else {
            return DropdownButtonFormField(
              hint: Text("Select class"),
              validator: (value){
                if(value == null){
                  return 'Select class';
                }else{
                  return null;
                }
              },
              items: _classNames.map<DropdownMenuItem<String>>((String value){
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: _selectedClass,
              onChanged: (_){
                setState(() {
                  _selectedClass = _ as String?;
                });
              },
              onSaved: (_){
                setState(() {
                  _selectedClass = _ as String?;
                });
              },
            );
          }
        },
      ),
    );
  }
  Widget boardDropDown(){
    return ListTile(
      leading: Icon(Icons.assignment_rounded),
      title: FutureBuilder(
        future: _getAllBoard(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return CircularProgressIndicator();
          else {
            return DropdownButtonFormField(
              hint: Text("Select board"),
              validator: (value){
                if(value == null){
                  return 'Select board';
                }else{
                  return null;
                }
              },
              items: _boardNames.map<DropdownMenuItem<String>>((String value){
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: _selectedBoard,
              onChanged: (_){
                setState(() {
                  _selectedBoard = _ as String?;
                });
              },
              onSaved: (_){
                setState(() {
                  _selectedBoard = _ as String?;
                });
              },
            );
          }
        },
      ),
    );
  }
  Widget subjectDropDown(){
    return ListTile(
      leading: Icon(Icons.menu_book),
      title: FutureBuilder(
        future: _getAllSubject(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return CircularProgressIndicator();
          else {
            return DropdownButtonFormField(
              hint: Text("Select subject"),
              validator: (value){
                if(value == null){
                  return 'Select subject';
                }else{
                  return null;
                }
              },
              items: _subjectNames.map<DropdownMenuItem<String>>((String value){
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: _selectedSubject,
              onChanged: (_){
                setState(() {
                  _selectedSubject = _ as String?;
                });
              },
              onSaved: (_){
                setState(() {
                  _selectedSubject = _ as String?;
                });
              },
            );
          }
        },
      ),
    );
  }
  Widget sessionDaySelector(){
    return MultiSelectDialogField(
      key: _multiSelectKey,
      buttonIcon: Icon(Icons.add),
      listType: MultiSelectListType.CHIP,
      buttonText: Text("Select day"),
      title: Text("Pick session day(s)"),
      items: sessionDays.map((e) => MultiSelectItem<String>(e,e)).toList(),
      onSaved: (values){
        _selectedSessionDays = values!.map((e) => e.toString()).toList();
      },
      onConfirm: (values){
        setState(() {
          _selectedSessionDays = values.map((e) => e.toString()).toList();
        });
        print(_selectedSessionDays);
      },
      validator: (value){
        if(value == null || value.isEmpty){
          return "Required session day";
        }return null;
      },
      /*chipDisplay: MultiSelectChipDisplay<String>(
        items: _selectedSessionDays.map((e) => MultiSelectItem<String>(e,e)).toList(),
        icon: Icon(Icons.close),

        onTap: (value) {
          setState(() {
            _selectedSessionDays.remove(value);
            _selectedSessionDays = [];
          });
      }),*/
    );
  }
  Widget startTimeField() {
    return DateTimePicker(
      controller: _sessionStartTimeController,
      type: DateTimePickerType.time,
      locale: Locale('en', 'US'),
      use24HourFormat: false,
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
      onChanged: (_){
        setState(() {
          _startTime = DateFormat.jm().format(DateFormat("hh:mm").parse(_));
        });
        //print(_startTime);
      },
      onSaved: (value){
        setState(() {
          _startTime = DateFormat.jm().format(DateFormat("hh:mm").parse(value!));
        });
      },
    );
  }
  Widget endTimeField() {
    return DateTimePicker(
      controller: _sessionEndTimeController,
      type: DateTimePickerType.time,
      locale: Locale('en', 'US'),
      use24HourFormat: false,
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
      onChanged: (_){
        setState(() {
          _endTime = DateFormat.jm().format(DateFormat("hh:mm").parse(_));
        });
        //print(_startTime);
      },
      onSaved: (value){
        setState(() {
          _endTime = DateFormat.jm().format(DateFormat("hh:mm").parse(value!));
        });
      },
    );
  }
  Widget feesField() {
    return TextFormField(
      controller: _feesController,
      decoration: InputDecoration(
          icon: Icon(Icons.attach_money_rounded),
          labelText: "Fees"
      ),
      keyboardType: TextInputType.number,
      validator: (value){
        if(value!.isEmpty){
          return 'Fees cannot be empty';
        }else{
          return null;
        }
      },
      onChanged: (_){
        setState(() {
          _fees = double.parse(_);
        });
      },
      onSaved: (value){
        setState(() {
          _fees = double.parse(value!);
        });
      },
    );
  }

  _save()async{
    int? _classId = await ClassHelper.instance.getClassId(_selectedClass!);
    int? _boardId = await BoardHelper.instance.getBoardId(_selectedBoard!);
    int? _subjectId = await SubjectHelper.instance.getSubjectId(_selectedSubject!);

    SessionModel newSession = SessionModel(studentId: widget.studentId,classId: _classId!,boardId: _boardId!,subjectId: _subjectId!,sessionSlot: _selectedSessionDays.toString(), startTime: _startTime,endTime: _endTime, fees: _fees);
    SessionHelper.instance.insertSession(newSession);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: BackButton(
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text(widget.studentName + "'s new session"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  classDropDown(),
                  boardDropDown(),
                  subjectDropDown(),
                  sessionDaySelector(),
                  startTimeField(),
                  endTimeField(),
                  feesField(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: (){
                        setState(() {
                          //Save
                          if(_formKey.currentState!.validate()){
                            _save();
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
      ),
    );
  }
}
