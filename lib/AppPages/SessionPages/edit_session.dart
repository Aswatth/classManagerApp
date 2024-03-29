import 'package:class_manager/Model/fee.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class EditSession extends StatefulWidget {
  StudentModel student;
  SessionModel session;
  FeeModel feeModel;
  EditSession({Key? key,required this.student, required this.session, required this.feeModel}) : super(key: key);

  @override
  _EditSessionState createState() => _EditSessionState();
}

class _EditSessionState extends State<EditSession> {
  final _formKey = GlobalKey<FormState>();
  final _multiSelectKey = GlobalKey<FormFieldState>();

  List<SubjectModel> _subjectList = [];
  String _selectedSubject = '';

  List<String> sessionDays = ["Weekday","Weekend","Mon","Tue","Wed","Thur","Fri","Sat","Sun"];
  List<String> _selectedSessionDays = [];
  String _startTime = '';
  String _endTime = '';
  double _fees = 0;

  late TextEditingController _sessionStartTimeController;
  late TextEditingController _sessionEndTimeController;
  late TextEditingController _feesController;

  getAllSubject() async{
    List<SubjectModel> _temp = await SubjectHelper.instance.getAllSubject();
    setState(() {
      _subjectList = _temp;
    });
  }

  //Session details
  Widget subjectDropDown(){
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
          _selectedSubject = _ as String;
        });
      },
      onSaved: (_){
        setState(() {
          _selectedSubject = _ as String;
        });
      },
    );
  }

  Widget sessionDaySelector(){
    return MultiSelectDialogField(
      initialValue: _selectedSessionDays,
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
        //print(_selectedSessionDays);
      },
      validator: (value){
        if(value == null || value.isEmpty){
          return "Required session day";
        }return null;
      },
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
          //print(_startTime);
        });
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
          //print(_endTime);
        });
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
          labelText: "Fees",
          suffixIcon: IconButton(
            icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
            onPressed: (){
              setState(() {
                _feesController.clear();
              });
            },
          )
      ),
      keyboardType: TextInputType.number,
      validator: (value){
        if(value!.isEmpty){
          return 'Fees cannot be empty';
        }else{
          return null;
        }
      },
      onSaved: (value){
        setState(() {
          //print("Fees value:"+value!.toString());
          _fees = double.parse(value!);
        });
      },
    );
  }

  Future<bool> updateFee()async{
    List<FeeModel> feeModelList = await FeeHelper.instance.getPendingFee(widget.student.id!, widget.session.subjectName);
    FeeModel oldFeeModel = feeModelList.first;
    FeeModel newFeeModel = FeeModel.createNewFeeData(feeStudentId: widget.student.id!, feeSubjectName: _selectedSubject, fees: _fees, month: oldFeeModel.month, year: oldFeeModel.year, paidOn: oldFeeModel.paidOn);

    return await FeeHelper.instance.update(oldFeeModel, newFeeModel);
  }

  updateSession()async{
    SessionModel session = SessionModel.createNewSession(studentId: widget.student.id!, subjectName: _selectedSubject, startTime: _startTime, endTime: _endTime, sessionSlot: _selectedSessionDays.toString());

    bool isSessionUpdateSuccessful = await SessionHelper.instance.update(widget.session,session);

    bool isFeeUpdateSuccessful = await updateFee();

    if(isSessionUpdateSuccessful && isFeeUpdateSuccessful){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Session updated successfully!"),
      ),);
    }
  }

  _save() async{
    _formKey.currentState!.save();
    await updateSession();
    Navigator.pop(context);
  }

  @override
  void initState(){
    super.initState();

    getAllSubject();

    _feesController = TextEditingController(text: widget.feeModel.fees.toString());
    _selectedSubject = widget.session.subjectName;
    _selectedSessionDays = widget.session.sessionSlot.replaceAll(",", "").replaceAll("[", "").replaceAll("]", "").split(" ").toList();
    _sessionStartTimeController = TextEditingController(text: widget.session.startTime.split(" ")[0]);
    _sessionEndTimeController = TextEditingController(text: widget.session.endTime.split(" ")[0]);

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
        title: Text("Edit Session"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              subjectDropDown(),
              sessionDaySelector(),
              startTimeField(),
              endTimeField(),
              feesField(),
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

