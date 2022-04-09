import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

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

  final _formKey = GlobalKey<FormState>();

  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(
          icon: Icon(Icons.school_rounded),
          labelText: "Student name"
      ),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      validator: (value){
        if(value!.isEmpty){
          return 'Student name cannot be empty';
        }
      },
      onSaved: (value){
        _name = value!;
      },
    );
  }
  Widget dobField() {
    return DateTimePicker(
      initialValue: '',
      dateMask: 'dd-MMM-yyyy',
      decoration: InputDecoration(
        icon: Icon(Icons.calendar_today_rounded),
        labelText: "Student DOB",
      ),
      validator: (value){
        if(value!.isEmpty){
          return 'Student DOB cannot be empty';
        }
      },
      firstDate: DateTime(1999),
      lastDate: DateTime(2100),
      onSaved: (value){
        _dob = DateTime.parse(value!);
      },
    );
  }
  Widget studentPhoneNumberField() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.call),
        labelText: "Student phone number",
      ),
      keyboardType: TextInputType.number,
      maxLength: 10,
      validator: (value){
        if(value!.isEmpty){
          return 'Student number cannot be empty';
        }
      },
      onSaved: (value){
        _studentPhoneNumber = value!;
      },
    );
  }
  Widget parentPhoneNumber1Field(){
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.call),
        labelText: "Parent phone number 1",
      ),
      keyboardType: TextInputType.number,
      maxLength: 10,
      validator: (value){
        if(value!.isEmpty){
          return 'Parent number cannot be empty';
        }
      },
      onSaved: (value){
        _parentPhoneNumber1 = value!;
      },
    );
  }
  Widget parentPhoneNumber2Field(){
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.call),
        labelText: "Parent phone number 2",
      ),
      keyboardType: TextInputType.number,
      maxLength: 10,
      onSaved: (value){
        _parentPhoneNumber2 = value!;
      },
    );
  }
  Widget locationField() {
    return TextFormField(
      decoration: InputDecoration(
          icon: Icon(Icons.location_on_rounded),
          labelText: "Location"
      ),
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      validator: (value){
        if(value!.isEmpty){
          return 'Location cannot be empty';
        }
      },
      onSaved: (value){
        _location = value!;
      },
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
          title: Text("Add new student"),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: (){
                //Save
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();
                }
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
                Text(
                  "\nSession details",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
