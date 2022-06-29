import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class StudentSessionHelper{
  static final StudentSessionHelper instance = StudentSessionHelper._privateConstructor();

  StudentSessionHelper._privateConstructor(){}

  factory StudentSessionHelper()
  {
    return instance;
  }

  Future<List<StudentSessionModel>> getAllData()async{
    Database db = await DatabaseHelper.instance.database;

    List<Map<String,dynamic>> data = await db.rawQuery('''
    SELECT STUDENT.*, SESSION.* FROM ${StudentHelper.instance.studentTableName} STUDENT
    LEFT JOIN ${SessionHelper.instance.sessionTableName} SESSION
    ON SESSION.${SessionHelper.instance.colStudentId} = STUDENT.${StudentHelper.instance.colId}
    ''');

    return data.map((json) => StudentSessionModel.fromMap(json)).toList();
  }
}

class StudentSessionModel{
  //Student
  int id;
  String studentPhoneNumber;
  String parentPhoneNumber1;
  String? parentPhoneNumber2;
  String schoolName;
  String name;
  DateTime dob;
  String className;
  String boardName;
  String location;

  //Session
  int? studentId;
  String? subjectName;
  String? startTime;
  String? endTime;
  String? sessionSlot;

  StudentSessionModel({
    required this.id,
    required this.studentPhoneNumber,
    required this.parentPhoneNumber1,
    required this.parentPhoneNumber2,
    required this.name,
    required this.dob,
    required this.className,
    required this.boardName,
    required this.schoolName,
    required this.location,
    required this.studentId,
    required this.subjectName,
    required this.startTime,
    required this.endTime,
    required this.sessionSlot
  });

  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'studentPhoneNumber':studentPhoneNumber,
      'parentPhoneNumber1':parentPhoneNumber1,
      'parentPhoneNumber2':parentPhoneNumber2,
      'name':name,
      'dob':DateFormat('dd-MMM-yyyy').format(dob).toString(),
      'schoolName': schoolName,
      'className': className,
      'boardName': boardName,
      'location':location,
      'studentId': studentId,
      'subjectName': subjectName,
      'startTime': startTime,
      'sessionSlot':sessionSlot,
      'endTime': endTime
    };
  }

  factory StudentSessionModel.fromMap(Map<String,dynamic> jsonToParse) => StudentSessionModel(
      id: jsonToParse['id'],
      studentPhoneNumber: jsonToParse['studentPhoneNumber'],
      parentPhoneNumber1: jsonToParse['parentPhoneNumber1'],
      parentPhoneNumber2: jsonToParse['parentPhoneNumber2'],
      name:  jsonToParse['name'],
      dob:  DateFormat('dd-MMM-yyyy').parse(jsonToParse['dob']),
      schoolName: jsonToParse['schoolName'],
      className: jsonToParse['className'],
      boardName: jsonToParse['boardName'],
      location: jsonToParse['location'],
      studentId: jsonToParse['studentId'] ?? -1,
      subjectName: jsonToParse['subjectName'],
      startTime: jsonToParse['startTime'],
      endTime: jsonToParse['endTime'],
      sessionSlot: jsonToParse['sessionSlot']
  );

  @override
  String toString() {
    return 'StudentSessionModel{id: $id, studentPhoneNumber: $studentPhoneNumber, parentPhoneNumber1: $parentPhoneNumber1, parentPhoneNumber2: $parentPhoneNumber2, schoolName: $schoolName, name: $name, dob: $dob, className: $className, boardName: $boardName, location: $location, studentId: $studentId, subjectName: $subjectName, startTime: $startTime, endTime: $endTime, sessionSlot: $sessionSlot}';
  }
}