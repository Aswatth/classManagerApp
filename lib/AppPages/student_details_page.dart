import 'package:class_manager/AppPages/add_student_page.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({Key? key}) : super(key: key);

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  final _formKey = GlobalKey<FormState>();
  void addStudent()
  {
    String _studentPhoneNumber;
    String _parentPhoneNumber1;
    String _parentPhoneNumber2;
    String _name;
    DateTime _dob;
    String _area;

    Alert(
      context: context,
      title: "Add new student",
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (_){
                if(_ == null || _.isEmpty){
                  return 'This field is mandatory';
                }
                else{
                  return null;
                }
              },

            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(child: Text("Add"), onPressed: (){
          //Add student
          if(_formKey.currentState!.validate()){
            print("VALID");
          }
        }),
        DialogButton(child: Text("Cancel"), onPressed: (){
          //Discard changes
          Navigator.pop(context);
        })
      ]
    ).show();
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
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddStudent())
            );
          },
        ),
        body: Container(),
      ),
    );
  }
}
