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
  String _schoolName = '';
  String _studentPhoneNumber = '';
  String _parentPhoneNumber1 = '';
  String _parentPhoneNumber2 = '';
  DateTime _dob = DateTime.now();
  String _location = '';

  List<ClassModel> _classList = [];
  String? _selectedClass = null;

  List<BoardModel> _boardList = [];
  String? _selectedBoard = null;

  _getAllClass() async{
    _classList = await ClassHelper.instance.getAllClass();
  }
  _getAllBoard() async{
    _boardList = await BoardHelper.instance.getAllBoard();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _studentPhnNumController = TextEditingController();
  final TextEditingController _parentPhnNum1Controller = TextEditingController();
  final TextEditingController _parentPhnNum2Controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Widget nameField() {
    return TextFormField(
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
      )
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

    StudentModel student = StudentModel.createNewStudent(
        studentPhoneNumber:  _studentPhoneNumber,
        parentPhoneNumber1: _parentPhoneNumber1,
        parentPhoneNumber2: _parentPhoneNumber2,
        name: _name,
        dob: _dob,
        schoolName: _schoolName,
        classData: _selectedClassModel,
        boardData: _selectedBoardModel,
        location: _location
    );
    StudentHelper.instance.insertStudent(student);
  }

  @override
  void initState() {
    setState(() {
      _getAllClass();
      _getAllBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US')
      ],
      home: Scaffold(
        resizeToAvoidBottomInset: true,
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
              shrinkWrap: true,
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
