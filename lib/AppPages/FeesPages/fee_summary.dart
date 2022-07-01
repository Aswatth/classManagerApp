import 'package:class_manager/Model/fee.dart';
import 'package:class_manager/Model/student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FeeList extends StatefulWidget {
  StudentModel studentModel;
  FeeList({Key? key,required this.studentModel}) : super(key: key);

  @override
  _FeeListState createState() => _FeeListState();
}

class _FeeListState extends State<FeeList> {

  List<FeeModel> _feeList = [];
  List<DataRow> _rows = [];

  List<String> monthYearList = [];

  final Map<String,int> monthMapping = {"JAN":1,"FEB":2,"MAR":3,"APR":4,"MAY":5,"JUN":6,"JUL":7,"AUG":8,"SEP":9,"OCT":10,"NOV":11,"DEC":12};

  String _selectedMonthYear = '';

  double _feeSum = 0.0;

  getFeeData() async{

    List<FeeModel> temp = await FeeHelper.instance.getFeeByStudentId(widget.studentModel.id!);

    List<String> tempMonthYear = await FeeHelper.instance.getMonthYearByStudentId(widget.studentModel.id!);


    setState(() {
      _feeSum = 0;
      _feeList = temp;

      monthYearList = tempMonthYear;

      if(_selectedMonthYear.isNotEmpty) {
          _feeList.removeWhere((element) => element.month != monthMapping[_selectedMonthYear.split('-')[0].toUpperCase()]);
          _feeList.removeWhere((element) => element.year != int.parse(_selectedMonthYear.split('-')[1]));
      }

      _feeList.forEach((element) {
        _feeSum += element.fees;
      });

      _rows = _feeList.map((e) => DataRow(cells: [
        DataCell(Text(e.feeSubjectName)),
        DataCell(Text("${DateFormat("MMM").format(DateTime(0,e.month))}-${e.year}")),
        DataCell(Text(e.fees.toString())),
        DataCell(
            e.paidOn==null?Text("Pending",style: TextStyle(color: Colors.red),): Text(DateFormat("dd-MMM-yyyy").format(e.paidOn!))
        ),
      ])).toList();
      _rows.add(DataRow(cells: [
        DataCell(Text("-")),
        DataCell(Text("-")),
        DataCell(Text(_feeSum.toString())),
        DataCell(Text("-")),
      ]));

    });

  }

  Widget monthDropDown(){
    return DropdownButtonFormField(
      value: _selectedMonthYear.isEmpty?null:_selectedMonthYear,
      hint: Text("Select Month-Year"),
      items: monthYearList.map<DropdownMenuItem<String>>((String data){
        return DropdownMenuItem(
          value: data,
          child: Text(data),
        );
      }).toList(),
      onChanged: (_){
        setState(() {
          _selectedMonthYear = _ as String;
          print(_selectedMonthYear);
          getFeeData();
        });
      },
    );
  }


  delete() async{
    bool isSuccessful = await FeeHelper.instance.deleteSummary(widget.studentModel.id!);

    if(isSuccessful){
      if(_feeList.length != 0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Fees summary deleted successfully!"),
        ),);
        getFeeData();
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Fees summary empty"),
        ),);
      }
    }
  }

  deleteConfirmation(){
    Alert(
        context: context,
        content: Text("Are you sure you want to delete ${widget.studentModel.name}'s  fee summary"),
        buttons: [
          DialogButton(
            child: Text("No"),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          DialogButton(
            child: Text("Yes"),
            onPressed: (){
              delete();
              Navigator.pop(context);
            },
          )
        ]
    ).show();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getFeeData();
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
        title: Text("${widget.studentModel.name}'s fees summary"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: monthDropDown(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: (){
                  //Clear dropdown
                  setState(() {
                    _selectedMonthYear = '';

                    getFeeData();
                  });
                },
                child: Text("Clear"),
              ),
              ElevatedButton(
                onPressed: (){
                  //Delete summary
                  setState(() {
                    deleteConfirmation();
                  });
                },
                child: Text("Delete summary"),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)
                ),
                child: InteractiveViewer(
                  constrained: false,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text("Subject"),
                      ),
                      DataColumn(
                        label: Text("Month-Year"),
                      ),
                      DataColumn(
                        label: Text("Fees"),
                      ),
                      DataColumn(
                        label: Text("Paid on"),
                      ),
                    ],
                    rows: _rows,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
