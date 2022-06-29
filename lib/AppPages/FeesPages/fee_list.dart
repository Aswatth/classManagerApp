import 'package:class_manager/Model/fee.dart';
import 'package:class_manager/Model/student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeeList extends StatefulWidget {
  StudentModel studentModel;
  FeeList({Key? key,required this.studentModel}) : super(key: key);

  @override
  _FeeListState createState() => _FeeListState();
}

class _FeeListState extends State<FeeList> {

  List<FeeModel> _feeList = [];
  List<DataRow> _rows = [];

  double _feeSum = 0.0;

  getFeeData() async{
    List<FeeModel> temp = await FeeHelper.instance.getFeeByStudentId(widget.studentModel.id!);

    setState(() {
      _feeList = temp;
      _feeList.forEach((element) {
        _feeSum += element.fees;
      });
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
        title: Text("Fees summary"),
      ),
      body: InteractiveViewer(
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
    );
  }
}
