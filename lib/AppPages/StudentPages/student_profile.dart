import 'package:class_manager/AppPages/SessionPages/add_session.dart';
import 'package:class_manager/AppPages/SessionPages/edit_session.dart';
import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StudentProfile extends StatefulWidget {
  StudentModel studentModel;
  StudentProfile({Key? key,required this.studentModel}) : super(key: key);

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {

  String _name = '';
  String _schoolName = '';
  String _studentPhoneNumber = '';
  String _parentPhoneNumber1 = '';
  String _parentPhoneNumber2 = '';
  DateTime _dob = DateTime.now();
  String _location = '';
  String _className = '';
  String _boardName = '';

  List<ClassModel> _classList = [];
  List<BoardModel> _boardList = [];

  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _studentPhnNumController = TextEditingController();
  final TextEditingController _parentPhnNum1Controller = TextEditingController();
  final TextEditingController _parentPhnNum2Controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
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

  Future<List<SessionModel>>getSession()async{
    List<SessionModel> temp = await SessionHelper.instance.getSessionByStudentId(widget.studentModel.id!);

    setState(() {

    });
    return temp;
  }

  Widget nameField() {
    return TextFormField(
      enabled: _isEditing,
      controller: _nameController,
      decoration: InputDecoration(
          icon: Icon(Icons.person),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
            onPressed: (){
              setState(() {
                _nameController.clear();
              });
            },
          ),
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
      controller: _dobController,
      type: DateTimePickerType.date,
      dateMask: 'dd-MMM-yyyy',
      decoration: InputDecoration(
        icon: Icon(Icons.cake),
        labelText: "Student DOB",
        suffixIcon: IconButton(
          icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
          onPressed: (){
            setState(() {
              _dobController.clear();
            });
          },
        ),
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
        icon: Icon(Icons.school),
        labelText: "School name",
        suffixIcon: IconButton(
          icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
          onPressed: (){
            setState(() {
              _schoolNameController.clear();
            });
          },
        ),
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
          value: _className,
          onChanged: _isEditing?(_){
            setState(() {
              _className = (_ as String?)!;
            });
          }:null,
          onSaved: (_){
            setState(() {
              _className = (_ as String?)!;
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
          value: _boardName,
          onChanged: _isEditing?(_){
            setState(() {
              _boardName = (_ as String?)!;
            });
          }:null,
          onSaved: (_){
            setState(() {
              _boardName = (_ as String?)!;
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
        suffixIcon: IconButton(
          icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
          onPressed: (){
            setState(() {
              _studentPhnNumController.clear();
            });
          },
        ),
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
        suffixIcon: IconButton(
          icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
          onPressed: (){
            setState(() {
              _parentPhnNum1Controller.clear();
            });
          },
        ),
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
        suffixIcon: IconButton(
          icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
          onPressed: (){
            setState(() {
              _parentPhnNum2Controller.clear();
            });
          },
        ),
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
        icon: Icon(Icons.location_on),
        labelText: "Location",
        suffixIcon: IconButton(
          icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
          onPressed: (){
            setState(() {
              _locationController.clear();
            });
          },
        ),
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

  deleteSession(String subjectName)async{
    await SessionHelper.instance.delete(widget.studentModel.id!, subjectName);
  }

  updateStudent()async{
    bool isSuccessful = await StudentHelper.instance.update(widget.studentModel);

    if(isSuccessful){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Updated successfully!"),
      ),);
    }
  }

  _save(){
    print("SAVING");
    _formKey.currentState!.save();

    StudentModel _student = widget.studentModel;

    _student.studentPhoneNumber = _studentPhoneNumber;
    _student.parentPhoneNumber1 = _parentPhoneNumber1;
    _student.parentPhoneNumber2 = _parentPhoneNumber2;
    _student.name = _name;
    _student.schoolName = _schoolName;
    _student.dob = _dob;
    _student.location = _location;
    _student.className = _className;
    _student.boardName = _boardName;

    updateStudent();

    setState(() {
      widget.studentModel = _student;
      _isEditing = false;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllClass();
    getAllBoard();
    getSession();

    _nameController.text = widget.studentModel.name;
    _dobController.text = widget.studentModel.dob.toString();
    _schoolNameController.text = widget.studentModel.schoolName;
    _className = widget.studentModel.className;
    _boardName = widget.studentModel.boardName;
    _studentPhnNumController.text = widget.studentModel.studentPhoneNumber;
    _parentPhnNum1Controller.text = widget.studentModel.parentPhoneNumber1;
    _parentPhnNum2Controller.text = widget.studentModel.parentPhoneNumber2!;
    _locationController.text = widget.studentModel.location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: studentDrawer(),
      floatingActionButton: !_isEditing?FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: (){
          setState(() {
            _isEditing = !_isEditing;
          });
        },
      ):null,
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(widget.studentModel.name+"'s Profile"),
      ),
      body: Form(
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
              _isEditing?Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
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
                ),
              ):Container()
            ],
          ),
        ),
      ),
    );
  }
}
