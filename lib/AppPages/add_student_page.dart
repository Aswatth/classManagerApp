import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  String _name = '';
  String _studentPhoneNumber = '';
  String _parentPhoneNumber1 = '';
  String _parentPhoneNumber2 = '';
  DateTime _dob = DateTime.now();
  String _location = '';

  //Session details
  List<String> _classNames = [];
  String? _selectedClass = null;

  List<String> _boardNames = [];
  String? _selectedBoard = null;

  List<String> _subjectNames = [];
  String? _selectedSubject = null;
  String _startTime = '';
  String _endTime = '';
  double _fees = 0.0;
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

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _studentPhnNumController = TextEditingController();
  final TextEditingController _parentPhnNum1Controller = TextEditingController();
  final TextEditingController _parentPhnNum2Controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _sessionStartTimeController = TextEditingController();
  final TextEditingController _sessionEndTimeController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();

  Widget nameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
          icon: Icon(Icons.school_rounded),
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
  Widget studentPhoneNumberField() {
    return TextFormField(
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

  void _save()async{
    print("SAVING");
    _formKey.currentState!.save();

    StudentModel student = StudentModel.createNewStudent(
        studentPhoneNumber:  _studentPhoneNumber,
        parentPhoneNumber1: _parentPhoneNumber1,
        parentPhoneNumber2: _parentPhoneNumber2,
        name: _name,
        dob: _dob,
        location: _location
    );
    StudentHelper.instance.insertStudent(student);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US')
      ],
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text("Add new student"),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: (){

              },
            ),
          ],
        ),
        body:Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Student details",
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
                nameField(),
                dobField(),
                studentPhoneNumberField(),
                parentPhoneNumber1Field(),
                parentPhoneNumber2Field(),
                locationField(),
                Align(
                  alignment: Alignment.bottomRight,
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
