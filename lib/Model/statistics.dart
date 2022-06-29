import 'package:class_manager/Model/fee.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class StatisticsHelper {
  static final StatisticsHelper instance = StatisticsHelper
      ._privateConstructor();

  StatisticsHelper._privateConstructor(){}

  factory StatisticsHelper()
  {
    return instance;
  }

  Future<List<Statistics>> getStats() async {
    Database db = await DatabaseHelper.instance.database;

    List<Map<String,dynamic>> data = await db.rawQuery('''
    SELECT ${StudentHelper.instance.colClassName}, ${StudentHelper.instance.colBoardName}, ${FeeHelper.instance.colSubjectName}, SUM(FEE.${FeeHelper.instance.colFees}) as fees, COUNT(*) AS studentCount FROM ${StudentHelper.instance.studentTableName} STUDENT
    JOIN ${FeeHelper.instance.feeTableName} FEE
    ON FEE.${FeeHelper.instance.colStudentId} = STUDENT.${StudentHelper.instance.colId}
    WHERE FEE.${FeeHelper.instance.colMonth} = ${DateTime.now().month} AND FEE.${FeeHelper.instance.colYear} = ${DateTime.now().year}
    GROUP BY ${StudentHelper.instance.colClassName}, ${StudentHelper.instance.colBoardName}, ${FeeHelper.instance.colSubjectName}
    '''
      );

    return data.map((e) => Statistics.fromMap(e)).toList();

  }

}

class Statistics{
  //Student
  String className;
  String boardName;

  //Fees
  String feeSubjectName;
  double fees;

  int studentCount;

  Statistics({
    required this.className,
    required this.boardName,
    required this.feeSubjectName,
    required this.fees,
    required this.studentCount
  });

  Map<String,dynamic> toMap() {
    return {
      'className': className,
      'boardName': boardName,
      'feeSubjectName': feeSubjectName,
      'fees': fees.toString(),
      'studentCount': studentCount
    };
  }

  factory Statistics.fromMap(Map<String,dynamic> jsonToParse) => Statistics(
      className: jsonToParse['className'],
      boardName: jsonToParse['boardName'],
      feeSubjectName: jsonToParse['feeSubjectName'],
      fees:  jsonToParse['fees']??0,
      studentCount: jsonToParse['studentCount']??-1
  );

  @override
  String toString() {
    return 'Statistics{className: $className, boardName: $boardName, feeSubjectName: $feeSubjectName, fees: $fees, studentCount: $studentCount}';
  }
}