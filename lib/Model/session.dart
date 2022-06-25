import 'dart:convert';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class SessionHelper{
  final String sessionTableName = 'SESSION';

  //Columns
  final String _colStudentId = 'studentId';
  final String _colSubjectName = 'subjectName';
  final String _colSessionSlot = 'sessionSlot';
  final String _colStartTime = 'startTime';
  final String _colEndTime = 'endTime';
  final String _colFees = 'fees';

  static final SessionHelper instance = SessionHelper._privateConstructor();

  SessionHelper._privateConstructor(){
    _initialize();
  }

  factory SessionHelper()
  {
    return instance;
  }

  void _initialize()async{
    String _createStudentTable ='''
    CREATE TABLE IF NOT EXISTS $sessionTableName(
    $_colStudentId INT,
    $_colSubjectName VARCHAR,
    $_colSessionSlot VARCHAR,
    $_colStartTime VARCHAR,
    $_colEndTime VARCHAR,
    $_colFees FLOAT,
    PRIMARY KEY($_colStudentId,$_colSubjectName),
    FOREIGN KEY($_colStudentId) REFERENCES ${StudentHelper.instance.studentTableName}(${StudentHelper.instance.colId}) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY($_colSubjectName) REFERENCES ${SubjectHelper.instance.subjectTableName}(${SubjectHelper.instance.colSubjectName}) ON UPDATE CASCADE ON DELETE NO ACTION        
    );
     ''';

    Database db = await DatabaseHelper.instance.database;

    db.execute(_createStudentTable);
  }

  insert(SessionModel session)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(
        sessionTableName,
        where: '$_colStudentId = ? and $_colSubjectName = ?',
        whereArgs: [session.studentId,session.subjectName]);

    if(data.isEmpty)
    {
      //Insert
      db.insert(sessionTableName, session.toMap());
      print(session.toString()+" inserted successfully");
    }
    else{
      print(session.toString()+" already exists");
    }
  }

  update(SessionModel oldSession, SessionModel newSession)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if session already exists
    List<Map<String,dynamic>> data = await db.query(
        sessionTableName,
        where: '$_colStudentId = ? and $_colSubjectName = ?',
        whereArgs: [oldSession.studentId,oldSession.subjectName]);

    if(data.isNotEmpty){
      db.update(sessionTableName, newSession.toMap(),
          where: '$_colStudentId = ? and $_colSubjectName = ?',
          whereArgs: [oldSession.studentId,oldSession.subjectName]);
    }
  }

  delete(int studentId, String subjectName)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;
    await db.delete(
        sessionTableName,
        where: '$_colStudentId = ? and $_colSubjectName = ?',
        whereArgs: [studentId,subjectName]);
  }

  Future<List<SessionModel>> getSessionByStudentId(int studentId)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(sessionTableName,where: '$_colStudentId = ?',whereArgs: [studentId]);

    return data.map((json) => SessionModel.fromMap(json)).toList();
  }

  Future<List<SessionModel>> getSession(int studentId, String subjectName)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(sessionTableName,where: '$_colStudentId = ? and $_colSubjectName = ?',whereArgs: [studentId,subjectName]);

    return data.map((json) => SessionModel.fromMap(json)).toList();
  }

  Future<List<SessionModel>> getSessionBySubject(String subjectName)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(sessionTableName,where: '$_colSubjectName = ?',whereArgs: [subjectName]);

    return data.map((json) => SessionModel.fromMap(json)).toList();
  }

  Future<List<SessionModel>> getAllSession() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(sessionTableName);

    return data.map((json) => SessionModel.fromMap(json)).toList();
  }
}

class SessionModel{
  int studentId;
  String subjectName;
  String startTime;
  String endTime;
  String sessionSlot;
  double fees;

  SessionModel.createNewSession({
    required this.studentId,
    required this.subjectName,
    required this.startTime,
    required this.endTime,
    required this.sessionSlot,
    required this.fees
  });

  SessionModel({
    required this.studentId,
    required this.subjectName,
    required this.startTime,
    required this.endTime,
    required this.sessionSlot,
    required this.fees
  });

  Map<String,dynamic> toMap() {
    return {
      'studentId': studentId,
      'subjectName': subjectName,
      'startTime': startTime,
      'sessionSlot':sessionSlot,
      'endTime': endTime,
      'fees': fees.toString()
    };
  }
  factory SessionModel.fromMap(Map<String,dynamic> jsonString) => SessionModel(
      studentId: jsonString['studentId'],
      subjectName: jsonString['subjectName'],
      startTime: jsonString['startTime'],
      endTime: jsonString['endTime'],
      sessionSlot: jsonString['sessionSlot'],
      fees:  jsonString['fees']
  );

  @override
  String toString() {
    return 'SessionModel{studentId: $studentId, subjectName: $subjectName, startTime: $startTime, endTime: $endTime, sessionSlot: $sessionSlot, fees: $fees}';
  }
}