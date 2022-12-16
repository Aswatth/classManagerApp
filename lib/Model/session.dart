import 'dart:convert';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class SessionHelper{
  final String sessionTableName = 'SESSION';

  //Columns
  final String colStudentId = 'studentId';
  final String _colSubjectName = 'subjectName';
  final String _colSessionSlot = 'sessionSlot';
  final String _colStartTime = 'startTime';
  final String _colEndTime = 'endTime';

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
    $colStudentId INT,
    $_colSubjectName VARCHAR,
    $_colSessionSlot VARCHAR,
    $_colStartTime VARCHAR,
    $_colEndTime VARCHAR,
    PRIMARY KEY($colStudentId,$_colSubjectName),
    FOREIGN KEY($colStudentId) REFERENCES ${StudentHelper.instance.studentTableName}(${StudentHelper.instance.colId}) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY($_colSubjectName) REFERENCES ${SubjectHelper.instance.subjectTableName}(${SubjectHelper.instance.colSubjectName}) ON UPDATE CASCADE ON DELETE NO ACTION        
    );
     ''';

    Database db = await DatabaseHelper.instance.database;

    db.execute(_createStudentTable);
  }

  Future<bool> insert(SessionModel session)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(
        sessionTableName,
        where: '$colStudentId = ? and $_colSubjectName = ?',
        whereArgs: [session.studentId,session.subjectName]);

    if(data.isEmpty)
    {
      //Insert
      await db.insert(sessionTableName, session.toMap());
      print(session.toString()+" inserted successfully");
      return true;
    }
    else{
      print(session.toString()+" already exists");
      return false;
    }
  }

  Future<bool> update(SessionModel oldSession, SessionModel newSession)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if session already exists
    List<Map<String,dynamic>> data = await db.query(
        sessionTableName,
        where: '$colStudentId = ? and $_colSubjectName = ?',
        whereArgs: [oldSession.studentId,oldSession.subjectName]);

    if(data.isNotEmpty){
      await db.update(sessionTableName, newSession.toMap(),
          where: '$colStudentId = ? and $_colSubjectName = ?',
          whereArgs: [oldSession.studentId,oldSession.subjectName]);
      return true;
    }
    return false;
  }

  Future<bool> delete(int studentId, String subjectName)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;
    await db.delete(
        sessionTableName,
        where: '$colStudentId = ? and $_colSubjectName = ?',
        whereArgs: [studentId,subjectName]);
    return true;
  }
  Future<bool> deleteSessionForStudent(int studentId)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;
    await db.delete(
        sessionTableName,
        where: '$colStudentId = ?',
        whereArgs: [studentId]);
    return true;
  }

  Future<List<SessionModel>> getSessionByStudentId(int studentId)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(sessionTableName,where: '$colStudentId = ?',whereArgs: [studentId]);

    return data.map((json) => SessionModel.fromMap(json)).toList();
  }

  Future<List<SessionModel>> getSession(int studentId, String subjectName)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(sessionTableName,where: '$colStudentId = ? and $_colSubjectName = ?',whereArgs: [studentId,subjectName]);

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

  SessionModel.createNewSession({
    required this.studentId,
    required this.subjectName,
    required this.startTime,
    required this.endTime,
    required this.sessionSlot
  });

  SessionModel({
    required this.studentId,
    required this.subjectName,
    required this.startTime,
    required this.endTime,
    required this.sessionSlot
  });

  Map<String,dynamic> toMap() {
    return {
      'studentId': studentId,
      'subjectName': subjectName,
      'startTime': startTime,
      'sessionSlot':sessionSlot,
      'endTime': endTime
    };
  }
  factory SessionModel.fromMap(Map<String,dynamic> jsonString) => SessionModel(
      studentId: jsonString['studentId'],
      subjectName: jsonString['subjectName'],
      startTime: jsonString['startTime'],
      endTime: jsonString['endTime'],
      sessionSlot: jsonString['sessionSlot']
  );

  @override
  String toString() {
    return 'SessionModel{studentId: $studentId, subjectName: $subjectName, startTime: $startTime, endTime: $endTime, sessionSlot: $sessionSlot}';
  }
}