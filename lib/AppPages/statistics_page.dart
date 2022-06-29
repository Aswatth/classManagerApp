import 'package:class_manager/Model/statistics.dart';
import 'package:flutter/material.dart';

import '../Model/fee.dart';
import '../Model/student.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {

  List<Statistics> _statsList = [];

  List<DataRow> _rows = [];

  int _totalStudents = -1;
  double _totalFees = -1;

  Future<void> getStats()async{
    List<Statistics> temp = await StatisticsHelper.instance.getStats();

    _totalStudents = await StudentHelper.instance.getStudentCount();
    _totalFees = await FeeHelper.instance.getCurrentFeeSum();

    setState(() {
      _statsList = temp;
      _statsList.forEach((element) {
        _rows.add(DataRow(
          cells: [
            DataCell(
              Text("${element.className} - ${element.boardName}")
            ),
            DataCell(
                Text("${element.feeSubjectName}")
            ),
            DataCell(
                Text("${element.fees}")
            ),
            DataCell(
                Text("${element.studentCount}")
            ),
          ]
        ));
      });
    });
  }

  Widget dataTable(){
    return InteractiveViewer(
      constrained: false,
      child: DataTable(
          sortAscending: false,
          sortColumnIndex: 0,
          columns: [
            DataColumn(label: Text("Class-Board"),),
            DataColumn(label: Text("Subject"),),
            DataColumn(label: Text("Total fees"),numeric: true),
            DataColumn(label: Text("Student count"),numeric: true)
          ],
          rows: _rows
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stats for current month"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("Total students: ${_totalStudents}"),
          ),
          ListTile(
            title: Text("Fees: ${_totalFees}"),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: dataTable(),
                ),
              )
          )
        ],
      )
    );
  }
}
