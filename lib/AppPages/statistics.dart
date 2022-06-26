import 'package:flutter/material.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortAscending: false,
            sortColumnIndex: 0,
            columns: [
              DataColumn(label: Text("Class-Board"),),
              DataColumn(label: Text("Subject"),),
              DataColumn(label: Text("Student count"),numeric: true)
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(
                    Text("X-CBSE")
                  ),
                  DataCell(
                      Text("MATHS")
                  ),
                  DataCell(
                      Text("9")
                  )
                ]
              ),
              DataRow(
                  cells: [
                    DataCell(
                        Text("XI-ICSE"),
                    ),
                    DataCell(
                        Text("Science")
                    ),
                    DataCell(
                        Text("7")
                    )
                  ]
              )
            ],
          ),
        ),
      )
    );
  }
}
