import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class SessionHelper{
  final String sessionTableName = 'SESSION';

  //Columns
  final String _studentId = 'studentId';
  final String _subjectId = 'subjectId';
  final String _sessionSlot = 'sessionSlot';
  final String _startTime = 'startTime';
  final String _endTime = 'endTime';
  final String _fees = 'fees';

  //Student
  final String _studentTableName = StudentHelper.instance.studentTableName;
  final String _studentId_ref = StudentHelper.instance.id;

  //Subject
  final String _subjectTableName = SubjectHelper.instance.subjectTableName;
  final String _subjectId_ref = SubjectHelper.instance.id;

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
    $_studentId INTEGER,
    $_subjectId INTEGER,
    $_sessionSlot VARCHAR(100),
    $_startTime VARCHAR(10),
    $_endTime VARCHAR(10),
    $_fees FLOAT,
    FOREIGN KEY($_studentId) REFERENCES $_studentTableName($_studentId_ref),
    FOREIGN KEY($_subjectId) REFERENCES $_subjectTableName($_subjectId_ref),
    PRIMARY KEY($_studentId,$_subjectId)
    );
     ''';

    Database db = await DatabaseHelper.instance.database;

    //Enabling foreign keys
    await db.execute('PRAGMA foreign_keys = ON');

    db.execute(_createStudentTable);
  }

  void insertSession(SessionModel session)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(
        sessionTableName,
        where: '$_studentId = ? and $_subjectId = ?',
        whereArgs: [session.studentId,session.subjectId]);

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
        where: '$_studentId = ?',
        whereArgs: [session.studentId]);

    if(data.isNotEmpty){
      db.update(sessionTableName, session.toMap(),
          where: '$_studentId = ?',
          whereArgs: [session.studentId]);
    }
  }

  void delete(int studentId, int subjectId)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;
    await db.delete(
        sessionTableName,
        where: '$_studentId = ? and $_subjectId = ?',
        whereArgs: [studentId,subjectId]);
  }

  Future<List<SessionModel>> getSession(int studentId)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(sessionTableName,where: '$_studentId = ?',whereArgs: [studentId]);
    int dataCount = data.length;

    List<SessionModel> sessionList = [];

    for(int i = 0;i<dataCount;++i) {
      sessionList.add(SessionModel.fromMap(data[i]));
    }
    return sessionList;
  }
  Future<List<SessionModel>> getSearchedSession({int selectedSubjectId = -1})async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = [];

    if(selectedSubjectId == -1){
      return getAllSession();
    }else{
      String query = "";
      List<int> queryParams = [];
      query += "$_subjectId = ?";
      queryParams.add(selectedSubjectId);

      data = await db.query(sessionTableName,where: query,whereArgs: queryParams);
    }

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
  int studentId;
  int subjectId;
  String startTime;
  String endTime;
  String sessionSlot;
  double fees;

  SessionModel({
    required this.studentId,
    required this.subjectId,
    required this.startTime,
    required this.endTime,
    required this.sessionSlot,
    required this.fees
  });

  Map<String,dynamic> toMap() {
    return {
      'studentId': studentId,
      'subjectId': subjectId,
      'startTime': startTime,
      'sessionSlot':sessionSlot,
      'endTime': endTime,
      'fees': fees.toString()
    };
  }
  factory SessionModel.fromMap(Map<String,dynamic> json) => SessionModel(
      studentId: json['studentId'],
      subjectId: json['subjectId'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      sessionSlot: json['sessionSlot'],
      fees:  json['fees']
  );


}