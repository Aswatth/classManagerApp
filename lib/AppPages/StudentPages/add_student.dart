import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/student.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
  String _className = '';
  String _boardName = '';

  List<ClassModel> _classList = [];
  List<BoardModel> _boardList = [];

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

  Widget nameField() {
    return TextFormField(
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
          //value: _className,
          onChanged: (_){
            setState(() {
              _className = (_ as String?)!;
            });
          },
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
          //value: _boardName,
          onChanged: (_){
            setState(() {
              _boardName = (_ as String?)!;
            });
          },
          onSaved: (_){
            setState(() {
              _boardName = (_ as String?)!;
            });
          },
        )
    );
  }

  /*Widget studentPhoneNumberField() {
    return TextFormField(
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
  }*/

  Widget studentPhoneNumberField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntlPhoneField(
        controller: _studentPhnNumController,
        decoration: InputDecoration(
          labelText: 'Student phone number',
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
            onPressed: (){
              setState(() {
                _studentPhnNumController.clear();
              });
            },
          ),
        ),
        initialCountryCode: 'IN',
        onSaved: (value){
          setState(() {
            _studentPhoneNumber = value!.number.toString();
          });
        },
      ),
    );
  }

  Widget parentPhoneNumber1Field(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntlPhoneField(
        controller: _parentPhnNum1Controller,
        decoration: InputDecoration(
          labelText: 'Parent phone number 1',
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
            onPressed: (){
              setState(() {
                _parentPhnNum1Controller.clear();
              });
            },
          ),
        ),
        initialCountryCode: 'IN',
        onSaved: (value){
          setState(() {
            _parentPhoneNumber1 = value!.number.toString();
          });
        },
      ),
    );
  }

  Widget parentPhoneNumber2Field(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntlPhoneField(
        controller: _parentPhnNum2Controller,
        decoration: InputDecoration(
          labelText: 'Parent phone number 2',
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
            onPressed: (){
              setState(() {
                _parentPhnNum2Controller.clear();
              });
            },
          ),
        ),
        initialCountryCode: 'IN',
        onChanged: (value){
          print(value.completeNumber);
        },
        onSaved: (value){
          setState(() {
            _parentPhoneNumber2 = value!.number.toString();
          });
        },
      ),
    );
  }

  Widget locationField() {
    return TextFormField(
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

  insertStudent()async{
    StudentModel student = StudentModel.createNewStudent(
        studentPhoneNumber:  _studentPhoneNumber,
        parentPhoneNumber1: _parentPhoneNumber1,
        parentPhoneNumber2: _parentPhoneNumber2,
        name: _name,
        dob: _dob,
        schoolName: _schoolName,
        className: _className,
        boardName: _boardName,
        location: _location
    );
    bool isSuccessful = await StudentHelper.instance.insertStudent(student);

    if(isSuccessful){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Added new student ${student.name} successfully!"),
      ),);
      Navigator.pop(context);
    }
  }

  _save(){
    print("SAVING");
    _formKey.currentState!.save();
    insertStudent();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllClass();
    getAllBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Add student"),
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
              Padding(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
