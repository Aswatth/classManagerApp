import 'package:class_manager/Model/fee.dart';
import 'package:class_manager/Model/student.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FeesDetails extends StatefulWidget {
  StudentModel studentModel;
  FeesDetails({Key? key,required this.studentModel}) : super(key: key);

  @override
  _FeesDetailsState createState() => _FeesDetailsState();
}

class _FeesDetailsState extends State<FeesDetails> {

  List<FeeModel> _feeList = [];
  DateTime paidDate = DateTime.now();

  List<String> monthList = [];
  List<int> yearList = [];
  int _selectedMonth = -1;
  int _selectedYear = -1;

  Future<void> getFeeData()async{
    List<FeeModel> temp = await FeeHelper.instance.getLatestFeeByStudentId(widget.studentModel.id!);

    setState(() {
      _feeList = temp;

      if(_feeList.length > 0) {
        _selectedMonth = _feeList.first.month;
        _selectedYear = _feeList.first.year;
      }
      /*_feeList.forEach((element) {
        monthList.add("${element.month}-${DateFormat('MMM').format(DateTime(0,element.month))}");
        yearList.add(element.year);
      });*/
      /*monthList = monthList.toSet().toList();
      yearList = yearList.toSet().toList();*/
    });
  }

  /*Widget monthDropDown(){
    return DropdownButtonFormField(
      hint: Text("Select month"),
      validator: (value){
        if(value == null){
          return 'Select subject';
        }else{
          return null;
        }
      },
      items: monthList.map<DropdownMenuItem<String>>((String data){
        return DropdownMenuItem(
          value: data,
          child: Text(data),
        );
      }).toList(),
      onChanged: (_){
        setState(() {
          _selectedMonth = _ as String;
        });
      },
    );
  }

  Widget yearDropDown(){
    return DropdownButtonFormField(
      hint: Text("Select year"),
      validator: (value){
        if(value == null){
          return 'Select subject';
        }else{
          return null;
        }
      },
      items: yearList.map<DropdownMenuItem<int>>((int data){
        return DropdownMenuItem(
          value: data,
          child: Text(data.toString()),
        );
      }).toList(),
      onChanged: (_){
        setState(() {
          _selectedYear = _ as int;
        });
      },
    );
  }*/

  Widget dateTimeField() {
    return DateTimePicker(
      type: DateTimePickerType.date,
      dateMask: 'dd-MMM-yyyy',
      decoration: InputDecoration(
        icon: Icon(Icons.today),
        labelText: "Paid on",
      ),
      validator: (value){
        if(value!.isEmpty){
          return 'Paid on date cannot be empty';
        }else{
          return null;
        }
      },
      initialValue: paidDate.toString(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2100),
      onChanged: (value){
        setState(() {
          paidDate = DateTime.parse(value);
        });
      },
    );
  }

  Widget feeListWidget(){
    return ListView.builder(
      shrinkWrap:  true,
      itemCount: _feeList.length,
      itemBuilder: (context, index){
        FeeModel fee = _feeList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text(fee.feeSubjectName),
                subtitle: fee.paidOn == null?
                Text("Pending for ${DateFormat('MMM').format(DateTime(0, fee.month))} ${fee.year}", style: TextStyle(color: Colors.red),):
                Text("Paid on ${DateFormat('dd-MMM-yyyy').format(fee.paidOn!)}", style: TextStyle(color: Colors.green),),
                trailing: Text(fee.fees.toString()),
              ),
            ],
          ),
        );
      },
    );
  }

  saveAlert(){
    Alert(
      context: context,
      content: Text("Confirm payment? This action cannot be reversed."),
      buttons: [
        DialogButton(
          child: Text("No"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text("Confirm"),
          onPressed: (){
            _save();
            Navigator.pop(context);
          },
        ),

      ]
    ).show();
  }

  _save()async{
    print(paidDate);
    await FeeHelper.instance.setPaidOn(widget.studentModel.id!, _selectedMonth,_selectedYear,DateFormat("dd-MMM-yyyy").format(paidDate));

   setState(() {
     getFeeData();
   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFeeData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getFeeData,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.studentModel.name} ${widget.studentModel.className} ${widget.studentModel.boardName} fees"),
        ),
        body: Column(
          children: [
            Flexible(
              child: feeListWidget(),
            ),
            _feeList.isNotEmpty?dateTimeField():Container(),
            _feeList.isNotEmpty?Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: _feeList.length>0?(){
                    saveAlert();
                  }:null,
                  child: Text("Save")),
            ):Container()
          ],
        ),
      ),
    );
  }
}
