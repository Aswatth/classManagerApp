import 'dart:convert';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class FeeHelper{
  final String feeTableName = 'FEES_DETAILS';

  //Columns
  final String colStudentId = 'feeStudentId';
  final String colSubjectName = 'feeSubjectName';
  final String colFees = 'fees';
  final String colMonth = 'month';
  final String colYear = 'year';
  final String _colPaidOn = 'paidOn';

  static final FeeHelper instance = FeeHelper._privateConstructor();

  FeeHelper._privateConstructor(){
    _initialize();
  }

  factory FeeHelper()
  {
    return instance;
  }

  void _initialize()async{
    String _createStudentTable ='''
    CREATE TABLE IF NOT EXISTS $feeTableName(
    $colStudentId INT,
    $colSubjectName VARCHAR,
    $colFees FLOAT,
    $colMonth INT,
    $colYear INT,
    $_colPaidOn VARCHAR,    
    PRIMARY KEY($colStudentId,$colSubjectName,$colMonth,$colYear),
    FOREIGN KEY($colStudentId) REFERENCES ${StudentHelper.instance.studentTableName}(${StudentHelper.instance.colId}) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY($colSubjectName) REFERENCES ${SubjectHelper.instance.subjectTableName}(${SubjectHelper.instance.colSubjectName}) ON UPDATE CASCADE ON DELETE NO ACTION        
    );
     ''';

    Database db = await DatabaseHelper.instance.database;

    db.execute(_createStudentTable);
  }

  Future<bool> insert(FeeModel fees)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(
        feeTableName,
        where: '$colStudentId = ? and $colSubjectName = ? and ${colMonth} = ? and ${colYear} = ?',
        whereArgs: [fees.feeStudentId,fees.feeSubjectName,fees.month,fees.year]);

    if(data.isEmpty)
    {
      //Insert
      await db.insert(feeTableName, fees.toMap());
      print(fees.toString()+" inserted successfully");
      return true;
    }
    else{
      print(fees.toString()+" already exists");
      return false;
    }
  }

  Future<bool> update(FeeModel oldFeeData, FeeModel newFeeData)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if fees already exists
    List<Map<String,dynamic>> data = await db.query(
        feeTableName,
        where: '$colStudentId = ? and $colSubjectName = ? AND $colMonth = ? AND $colYear = ?',
        whereArgs: [oldFeeData.feeStudentId,oldFeeData.feeSubjectName,DateTime.now().month,DateTime.now().year]);

    if(data.isNotEmpty){
      print("Updating..");
      /*db.rawUpdate("UPDATE ${feeTableName} SET ${colSubjectName} = ? AND ${colFees} = ? WHERE ${colStudentId} = ? AND ${colSubjectName} = ? AND $colMonth = ? AND $colYear = ?",
          [newFeeData.feeSubjectName,newFeeData.fees,
            oldFeeData.feeStudentId,oldFeeData.feeSubjectName,DateTime.now().month,DateTime.now().year]);*/

      if(oldFeeData.feeSubjectName == newFeeData.feeSubjectName){
        await db.update(feeTableName, newFeeData.toMap(),
            where: '$colStudentId = ? and $colSubjectName = ? and $colMonth = ? and $colYear = ?',
            whereArgs: [oldFeeData.feeStudentId,oldFeeData.feeSubjectName,oldFeeData.month,oldFeeData.year]);
        return true;
      }
      else{
        await delete(oldFeeData.feeStudentId, oldFeeData.feeSubjectName);
        await insert(newFeeData);
        return true;
      }
    }
    return false;
  }

  Future<bool> delete(int feeStudentId, String feeSubjectName)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;
    await db.delete(
        feeTableName,
        where: '$colStudentId = ? and $colSubjectName = ? and $_colPaidOn IS NULL',
        whereArgs: [feeStudentId,feeSubjectName]);
    return true;
  }

  setPaidOn(int studentId, int month,int year,String paidOn) async{
    Database db = await DatabaseHelper.instance.database;

    /*List<Map> year  = await db.rawQuery("SELECT MAX(${colYear}) FROM ${feeTableName}");
    int latestYear = year.first.values.first;

    List<Map> month  = await db.rawQuery("SELECT MAX(${colMonth}) FROM ${feeTableName} WHERE ${colYear} = ${latestYear}");
    int latestMonth = month.first.values.first;*/

    List<Map> subject = await db.rawQuery("SELECT ${colSubjectName},${colFees} FROM ${feeTableName} WHERE ${colStudentId} = ? AND ${colMonth} = ? AND ${colYear} = ? AND ${_colPaidOn} IS NULL",[studentId,month,year]);
    List<String> subjectList = [];
    List<double> feesList = [];

    subject.forEach((element) {
      subjectList.add(element.values.first);
      feesList..add(element.values.last);
    });

    int nextMonth = -1;
    int nextYear = -1;
    if((month+1)%13==0){
      nextYear = year + 1;
      nextMonth = 1;
    }else{
      nextMonth = month + 1;
      nextYear = year;
    }

    //print("Latest month: $latestMonth, Next month: $nextMonth\nLatest year: $latestYear,Next year: $nextYear");

    for(int i=0; i<subjectList.length; ++i){
      await insert(FeeModel.createNewFeeData(feeStudentId: studentId, feeSubjectName: subjectList[i], fees: feesList[i], month: nextMonth, year: nextYear, paidOn: null));
    }

    await db.rawUpdate("UPDATE $feeTableName SET ${_colPaidOn} = ? WHERE ${colStudentId} = ? AND ${colMonth} = ? AND ${colYear} = ? AND ${_colPaidOn} IS NULL",
        [paidOn,studentId,month,year]);

    getAllFee();
  }

  Future<List<String>> getMonthYearByStudentId(int feeStudentId)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.rawQuery('''
    SELECT DISTINCT ${colMonth},${colYear} FROM ${feeTableName} WHERE $colStudentId = ? ORDER BY ${colMonth},${colYear} 
    ''',[feeStudentId]);
    //List<Map<String,dynamic>> data = await db.query(feeTableName,where: '$colStudentId = ?',whereArgs: [feeStudentId],orderBy: "${colMonth},${colYear} DESC");

    List<String> dataToReturn = [];

    data.forEach((element) {
      dataToReturn.add("${DateFormat("MMM").format(DateTime(0,element.values.first))}-${element.values.last}");
    });

    return dataToReturn;
  }

  Future<List<FeeModel>> getFeeByStudentId(int feeStudentId)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(feeTableName,where: '$colStudentId = ?',whereArgs: [feeStudentId],orderBy: "${colMonth},${colYear} DESC");

    /*data.forEach((element) {
      print(element);
    });*/

    return data.map((json) => FeeModel.fromMap(json)).toList();
  }

  Future<List<FeeModel>> getLatestFeeByStudentId(int feeStudentId)async{
    Database db = await DatabaseHelper.instance.database;

    List<Map<String,dynamic>> data = await db.query(feeTableName,where: '$colStudentId = ? AND $colMonth <= ? AND $colYear <= ? AND $_colPaidOn IS NULL',whereArgs: [feeStudentId,DateTime.now().month,DateTime.now().year]);

    return data.map((json) => FeeModel.fromMap(json)).toList();
  }

  Future<List<FeeModel>> getPendingFee(int feeStudentId, String feeSubjectName)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(feeTableName,where: '$colStudentId = ? and $colSubjectName = ? and $colMonth = ? and $colYear = ? and $_colPaidOn IS NULL',whereArgs: [feeStudentId,feeSubjectName,DateTime.now().month,DateTime.now().year]);

    if(data.length == 0){
      int nextMonth = -1;
      int nextYear = -1;
      int month = DateTime.now().month;
      int year = DateTime.now().year;
      if((month+1)%13==0){
        nextYear = year + 1;
        nextMonth = 1;
      }else{
        nextMonth = month + 1;
        nextYear = year;
      }
      data = await db.query(feeTableName,where: '$colStudentId = ? and $colSubjectName = ? and $colMonth = ? and $colYear = ? and $_colPaidOn IS NULL',whereArgs: [feeStudentId,feeSubjectName,nextMonth,nextYear]);
    }
    return data.map((json) => FeeModel.fromMap(json)).toList();
  }

  Future<List<FeeModel>> getFeeBySubject(String feeSubjectName)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(feeTableName,where: '$colSubjectName = ?',whereArgs: [feeSubjectName]);

    return data.map((json) => FeeModel.fromMap(json)).toList();
  }

  Future<List<FeeModel>> getAllFee() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(feeTableName);

    data.forEach((element) {
      print(element);
    });

    return data.map((json) => FeeModel.fromMap(json)).toList();
  }

  Future<double> getCurrentFeeSum()async{
    Database db = await DatabaseHelper.instance.database;

    List<Map> data = await db.rawQuery("SELECT SUM(${colFees}) FROM ${feeTableName} WHERE ${colMonth} = ? AND ${colYear} = ?",[DateTime.now().month,DateTime.now().year]);

    return data.first.values.first??0;
  }
}

class FeeModel{
  int feeStudentId;
  String feeSubjectName;
  double fees;
  int month;
  int year;
  DateTime? paidOn;

  FeeModel.createNewFeeData({
    required this.feeStudentId,
    required this.feeSubjectName,
    required this.fees,
    required this.month,
    required this.year,
    required this.paidOn
  });

  FeeModel({
    required this.feeStudentId,
    required this.feeSubjectName,
    required this.fees,
    required this.month,
    required this.year,
    required this.paidOn
  });

  Map<String,dynamic> toMap() {
    return {
      'feeStudentId': feeStudentId,
      'feeSubjectName': feeSubjectName,
      'fees': fees.toString(),
      'month': month,
      'year':year,
      'paidOn': paidOn == null?null:DateFormat('dd-MMM-yyyy').format(paidOn!).toString()
    };
  }
  factory FeeModel.fromMap(Map<String,dynamic> jsonString) => FeeModel(
      feeStudentId: jsonString['feeStudentId'],
      feeSubjectName: jsonString['feeSubjectName'],
      fees:  jsonString['fees'],
      month: jsonString['month'],
      year: jsonString['year'],
      paidOn:  jsonString['paidOn']==null?null:DateFormat('dd-MMM-yyyy').parse(jsonString['paidOn'])
  );

  @override
  String toString() {
    return 'FeeModel{feeStudentId: $feeStudentId, feeSubjectName: $feeSubjectName, fees: $fees, month: $month, year: $year, paidOn: $paidOn}';
  }
}