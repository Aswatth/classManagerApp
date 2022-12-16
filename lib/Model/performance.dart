import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class PerformanceHelper{
  final String performanceTableName = 'PERFORMANCE_DETAILS';

  //Columns
  final String colTestId = 'testId';
  final String colStudentId = 'performanceStudentId';
  final String colSubjectName = 'performanceSubjectName';
  final String colTestDate = 'testDate';
  final String colMarksScored =  'marksScored';
  final String colMaxMarks = 'maxMarks';
  final String colIsTuitionTest = 'isTuitionTest';

  static final PerformanceHelper instance = PerformanceHelper._privateConstructor();

  PerformanceHelper._privateConstructor(){
    _initialize();
  }

  factory PerformanceHelper()
  {
    return instance;
  }

  void _initialize()async{
    String _createStudentTable ='''
    CREATE TABLE IF NOT EXISTS $performanceTableName(
    $colTestId INTEGER PRIMARY KEY AUTOINCREMENT,
    $colStudentId INT,
    $colSubjectName VARCHAR,
    $colMarksScored FLOAT,
    $colMaxMarks FLOAT,
    $colTestDate VARCHAR,
    $colIsTuitionTest BOOLEAN,    
    FOREIGN KEY($colStudentId) REFERENCES ${StudentHelper.instance.studentTableName}(${StudentHelper.instance.colId}) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY($colSubjectName) REFERENCES ${SubjectHelper.instance.subjectTableName}(${SubjectHelper.instance.colSubjectName}) ON UPDATE CASCADE ON DELETE NO ACTION        
    );
     ''';

    Database db = await DatabaseHelper.instance.database;

    await db.execute(_createStudentTable);
  }

  Future<bool> insert(PerformanceModel performanceModel)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(
        performanceTableName,
        where: '$colStudentId = ? and $colSubjectName = ? and ${colTestDate} = ?',
        whereArgs: [performanceModel.performanceStudentId,performanceModel.performanceSubjectName,DateFormat("dd-MMM-yyyy").format(performanceModel.testDate)]);

    if(data.isEmpty)
    {
      //Insert
      await db.insert(performanceTableName, performanceModel.toMap());
      print(performanceModel.toString()+" inserted successfully");
      return true;
    }
    else{
      print(performanceModel.toString()+" already exists");
      return false;
    }
  }

  Future<bool> update(PerformanceModel olderPerformanceModel, PerformanceModel newPerformanceData)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if fees already exists
    List<Map<String,dynamic>> data = await db.query(
        performanceTableName,
        where: '${colStudentId} = ? and ${colSubjectName} = ? and ${colTestDate} = ?',
        whereArgs: [olderPerformanceModel.performanceStudentId,olderPerformanceModel.performanceSubjectName,DateFormat("dd-MMM-yyy").format(newPerformanceData.testDate)]);

    if(data.isEmpty){
      print("Updating..");

      await db.update(performanceTableName, newPerformanceData.toMap(),
          where: '$colTestId = ?',
          whereArgs: [olderPerformanceModel.testId]);
      return true;
    }
    else{
      if(olderPerformanceModel.testDate == newPerformanceData.testDate){
        await db.update(performanceTableName, newPerformanceData.toMap(),
            where: '$colTestId = ?',
            whereArgs: [olderPerformanceModel.testId]);
        return true;
      }
    }
    return false;
  }

  Future<bool> deleteData(int studentId,String subjectName)async{
    Database db = await DatabaseHelper.instance.database;
    await db.delete(
        performanceTableName,
        where: '$colStudentId = ? and $colSubjectName = ?',
        whereArgs: [studentId,subjectName]);

    return true;
  }

  Future<bool> delete(PerformanceModel performanceModel)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;
    await db.delete(
        performanceTableName,
        where: '$colTestId = ?',
        whereArgs: [performanceModel.testId]);
    return true;
  }

  Future<bool> deletePerformanceForStudent(int studentId)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;
    await db.delete(
        performanceTableName,
        where: '$colStudentId = ?',
        whereArgs: [studentId]);
    return true;
  }

  Future<List<PerformanceModel>> getPerformanceList(int studentId, String subjectName)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(
        performanceTableName,
        where: '$colStudentId = ? and $colSubjectName = ?',
        whereArgs: [studentId,subjectName],orderBy: colTestDate);

    return data.map((e) => PerformanceModel.fromMap(e)).toList();
  }
}

class PerformanceModel{
  int? testId;
  int performanceStudentId;
  String performanceSubjectName;
  DateTime testDate;
  double marksScored;
  double maxMarks;
  bool isTuitionTest;

  PerformanceModel({required this.testId,required this.performanceStudentId, required this.performanceSubjectName,
      required this.testDate, required this.marksScored, required this.maxMarks, required this.isTuitionTest});

  PerformanceModel.createNew({required this.performanceStudentId, required this.performanceSubjectName,
    required this.testDate, required this.marksScored, required this.maxMarks, required this.isTuitionTest});

  Map<String,dynamic> toMap() {
    return {
      'testId': testId,
      'performanceStudentId': performanceStudentId,
      'performanceSubjectName': performanceSubjectName,
      'testDate': DateFormat('dd-MMM-yyyy').format(testDate).toString(),
      'marksScored':marksScored,
      'maxMarks': maxMarks,
      'isTuitionTest': isTuitionTest==true?1:0
    };
  }

  factory PerformanceModel.fromMap(Map<String,dynamic> jsonToParse) => PerformanceModel(
      testId: jsonToParse['testId'],
      performanceStudentId: jsonToParse['performanceStudentId'],
      performanceSubjectName: jsonToParse['performanceSubjectName'],
      testDate:  DateFormat('dd-MMM-yyyy').parse(jsonToParse['testDate']),
      marksScored: jsonToParse['marksScored'],
      maxMarks: jsonToParse['maxMarks'],
      isTuitionTest: jsonToParse['isTuitionTest']==1?true:false
  );

  @override
  String toString() {
    return 'PerformanceModel{testId: $testId, performanceStudentId: $performanceStudentId, performanceSubjectName: $performanceSubjectName, testDate: $testDate, marksScored: $marksScored, maxMarks: $maxMarks, isTuitionTest: $isTuitionTest}';
  }
}