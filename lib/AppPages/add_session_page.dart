import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddSession extends StatefulWidget {
  final StudentModel student;
  //ReadableSessionData? sessionData;
  AddSession({Key? key,required this.student}) : super(key: key);

  @override
  _AddSessionState createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {

  final _formKey = GlobalKey<FormState>();
  final _multiSelectKey = GlobalKey<FormFieldState>();

  List<SubjectModel> _subjectList = [];
  String? _selectedSubject;
  SubjectModel? _selectedSubjectModel;

  List<String> sessionDays = ["Weekday","Weekend","Mon","Tue","Wed","Thur","Fri","Sat","Sun"];
  List<String> _selectedSessionDays = [];
  String _startTime = '';
  String _endTime = '';
  double _fees = 0.0;

  final TextEditingController _sessionStartTimeController = TextEditingController();
  final TextEditingController _sessionEndTimeController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();

  Future<List<SubjectModel>> _getAllSubject() async{
    List<SubjectModel> _temp = await SubjectHelper.instance.getAllSubject();
    setState(() {
      _subjectList = _temp;
    });
    return _temp;
  }

  //Session details
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
              items: _subjectList.map<DropdownMenuItem<String>>((SubjectModel subjectModel){
                return DropdownMenuItem(
                  value: subjectModel.subjectName,
                  child: Text(subjectModel.subjectName),
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

  _save(){
     for(int i =0;i<_subjectList.length;++i){
      if(_subjectList[i].subjectName == _selectedSubject){
        _selectedSubjectModel = _subjectList[i];
        break;
      }
    }
     SessionModel newSession = SessionModel(studentData: widget.student,subjectData: _selectedSubjectModel!,sessionSlot: _selectedSessionDays.toString(), startTime: _startTime,endTime: _endTime, fees: _fees);
     SessionHelper.instance.insertSession(newSession);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            subjectDropDown(),
            sessionDaySelector(),
            startTimeField(),
            endTimeField(),
            feesField(),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    _save();
                  }
                },
                child: Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
