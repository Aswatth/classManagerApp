import 'dart:convert';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class SessionHelper{
  final String sessionTableName = 'SESSION';

  //Columns
  final String _studentData = 'studentData';
  final String _subjectData = 'subjectData';
  final String _sessionSlot = 'sessionSlot';
  final String _startTime = 'startTime';
  final String _endTime = 'endTime';
  final String _fees = 'fees';

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
    $_sessionSlot VARCHAR(100),
    $_startTime VARCHAR(10),
    $_endTime VARCHAR(10),
    $_fees FLOAT,
    PRIMARY KEY($_studentData,$_subjectData)
    );
     ''';

    Database db = await DatabaseHelper.instance.database;

    db.execute(_createStudentTable);
  }

  void insertSession(SessionModel session)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(
        sessionTableName,
        where: '$_studentData = ? and $_subjectData = ?',
        whereArgs: [json.encode(session.studentData.toMap()),json.encode(session.subjectData.toMap())]);

    if(data.isEmpty)
    {
      print(session.toString()+" does not already exists");
      //Insert
      db.insert(sessionTableName, session.toMap());
    }
    else{
      print(session.toString()+" already exists");
    }
  }

  void update(SessionModel session)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if session already exists
    List<Map<String,dynamic>> data = await db.query(
        sessionTableName,
        where: '$_studentData = ?',
        whereArgs: [session.studentData.toMap()]);

    if(data.isNotEmpty){
      db.update(sessionTableName, session.toMap(),
          where: '$_studentData = ?',
          whereArgs: [json.encode(session.studentData.toMap())]);
    }
  }

  void delete(StudentModel studentData, SubjectModel subjectData)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;
    await db.delete(
        sessionTableName,
        where: '$_studentData = ? and $_subjectData = ?',
        whereArgs: [json.encode(studentData.toMap()),json.encode(subjectData.toMap())]);
  }

  Future<List<SessionModel>> getSession(StudentModel studentData)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(sessionTableName,where: '$_studentData = ?',whereArgs: [studentData]);
    int dataCount = data.length;

    List<SessionModel> sessionList = [];

    for(int i = 0;i<dataCount;++i) {
      sessionList.add(SessionModel.fromMap(data[i]));
    }
    return sessionList;
  }
  Future<List<SessionModel>> getSearchedSession({SubjectModel? selectedSubjectData})async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = [];

    if(selectedSubjectData == null){
      return getAllSession();
    }
    /*else{
      String query = "";
      List<int> queryParams = [];
      query += "$selectedSubjectData = ?";
      queryParams.add(selectedSubjectData);

      data = await db.query(sessionTableName,where: query,whereArgs: queryParams);
    }*/

    int dataCount = data.length;

    List<SessionModel> sessionList = [];

    for(int i = 0;i<dataCount;++i) {
      sessionList.add(SessionModel.fromMap(data[i]));
    }
    return sessionList;
  }

  Future<List<SessionModel>> getAllSession() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(sessionTableName);
    int dataCount = data.length;

    List<SessionModel> sessionList = [];

    for(int i = 0;i<dataCount;++i) {
      sessionList.add(SessionModel.fromMap(data[i]));
    }
    return sessionList;
  }
}

class SessionModel{
  StudentModel studentData;
  SubjectModel subjectData;
  String startTime;
  String endTime;
  String sessionSlot;
  double fees;

  SessionModel({
    required this.studentData,
    required this.subjectData,
    required this.startTime,
    required this.endTime,
    required this.sessionSlot,
    required this.fees
  });

  Map<String,dynamic> toMap() {
    return {
      'studentData': json.encode(studentData.toMap()),
      'subjectId': json.encode(subjectData.toMap()),
      'startTime': startTime,
      'sessionSlot':sessionSlot,
      'endTime': endTime,
      'fees': fees.toString()
    };
  }
  factory SessionModel.fromMap(Map<String,dynamic> jsonString) => SessionModel(
      studentData: StudentModel.fromMap(json.decode(jsonString['studentData'])),
      subjectData: SubjectModel.fromMap(json.decode(jsonString['subjectId'])),
      startTime: jsonString['startTime'],
      endTime: jsonString['endTime'],
      sessionSlot: jsonString['sessionSlot'],
      fees:  jsonString['fees']
  );

  @override
  String toString() {
    return 'SessionModel{studentData: ${studentData.toString()}, subjectData: ${subjectData.toString()}, startTime: $startTime, endTime: $endTime, sessionSlot: $sessionSlot, fees: $fees}';
  }
}