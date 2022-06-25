import 'dart:convert';

import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class StudentHelper{
  final String studentTableName = 'STUDENT';

  //Columns
  final String colId = 'id';
  final String _studentPhoneNumber = 'studentPhoneNumber';
  final String _parentPhoneNumber1 = 'parentPhoneNumber1';
  final String _parentPhoneNumber2 = 'parentPhoneNumber2';
  final String _name = 'name';
  final String _dob = 'dob';
  final String _schoolName = 'schoolName';
  final String _colClassName = 'className';
  final String _colBoardName = 'boardName';
  final String _location = 'location';

  static final StudentHelper instance = StudentHelper._privateConstructor();

  StudentHelper._privateConstructor(){
    _initialize();
  }
  void _initialize()async{
    String _createStudentTable ='''
    CREATE TABLE IF NOT EXISTS $studentTableName(
    $colId  INTEGER PRIMARY KEY AUTOINCREMENT,
    $_studentPhoneNumber VARCHAR(10),
    $_parentPhoneNumber1 VARCHAR(10),
    $_parentPhoneNumber2 VARCHAR(10),
    $_name VARCHAR,
    $_dob VARCHAR,
    $_schoolName VARCHAR,
    $_colClassName VARCHAR,
    $_colBoardName VARCHAR,
    $_location VARCHAR,    
    FOREIGN KEY($_colClassName) REFERENCES ${ClassHelper.instance.classTableName}(${ClassHelper.instance.colClassName}) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY($_colBoardName) REFERENCES ${BoardHelper.instance.boardTableName}(${BoardHelper.instance.colBoardName}) ON UPDATE CASCADE ON DELETE NO ACTION        
    )
     ''';

    Database db = await DatabaseHelper.instance.database;
    db.execute(_createStudentTable);
  }

  insertStudent(StudentModel student)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$_studentPhoneNumber = ? and $_parentPhoneNumber1 = ?',whereArgs: [student.studentPhoneNumber,student.parentPhoneNumber1]);

    if(data.isEmpty)
    {
      //Insert
      await db.insert(studentTableName, student.toMap());
      print(student.toMap().toString()+" inserted successfully");

    }
    else{
      print(student.toString()+" already exists");
    }
  }

  update(StudentModel student)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newBoardName already exists
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$colId = ?',whereArgs: [student.id]);

    if(data.isNotEmpty){
      await db.update(studentTableName, student.toMap(),where: '$colId = ?',whereArgs: [student.id]);

      print(student.toString() + " updated successfully");
    }
  }

  delete(int studentId)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newBoardName already exists
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$colId = ?',whereArgs: [studentId]);

    if(data.isNotEmpty) {
      await db.delete(studentTableName,where: '$colId = ?',whereArgs: [studentId]);

      print("Deleted successfully");
    }
  }

  Future<StudentModel?> getStudent(int studentId)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$colId = ?',whereArgs: [studentId]);
    if(data.length == 1){
      return StudentModel.fromMap(data[0]);
    }
    return null;
  }

  Future<List<StudentModel>> getStudentByClass(String className)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$_colClassName = ?',whereArgs: [className]);

    return data.map((json) => StudentModel.fromMap(json)).toList();
  }
  Future<List<StudentModel>> getStudentByBoard(String boardName)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$_colBoardName = ?',whereArgs: [boardName]);

    return data.map((json) => StudentModel.fromMap(json)).toList();
  }
  Future<List<StudentModel>> getStudentByClassAndBoard(String className,String boardName)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$_colClassName = ? and $_colBoardName = ?',whereArgs: [className,boardName]);

    return data.map((json) => StudentModel.fromMap(json)).toList();
  }
  
  Future<List<StudentModel>> getAllStudent() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(studentTableName);

    return data.map((json) => StudentModel.fromMap(json)).toList();
  }
}

class StudentModel{
  int? id;
  String studentPhoneNumber;
  String parentPhoneNumber1;
  String? parentPhoneNumber2;
  String schoolName;
  String name;
  DateTime dob;
  String className;
  String boardName;
  String location;

  StudentModel.createNewStudent({
    this.id,
    required this.studentPhoneNumber,
    required this.parentPhoneNumber1,
    this.parentPhoneNumber2,
    required this.name,
    required this.dob,
    required this.className,
    required this.boardName,
    required this.schoolName,
    required this.location
  });

  StudentModel({
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
  });

  factory StudentModel.fromMap(Map<String,dynamic> jsonToParse) => StudentModel(
      id: jsonToParse['id'],
      studentPhoneNumber: jsonToParse['studentPhoneNumber'],
      parentPhoneNumber1: jsonToParse['parentPhoneNumber1'],
      parentPhoneNumber2: jsonToParse['parentPhoneNumber2'],
      name:  jsonToParse['name'],
      dob:  DateFormat('dd-MMM-yyyy').parse(jsonToParse['dob']),
      schoolName: jsonToParse['schoolName'],
      className: jsonToParse['className'],
      boardName: jsonToParse['boardName'],
      location: jsonToParse['location']
  );

  Map<String,dynamic> toMap(){
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
      'location':location
    };
  }

  @override
  String toString() {
    return 'StudentModel{id: $id, studentPhoneNumber: $studentPhoneNumber, parentPhoneNumber1: $parentPhoneNumber1, parentPhoneNumber2: $parentPhoneNumber2, schoolName: $schoolName, name: $name, dob: $dob, className: $className, boardName: $boardName, location: $location}';
  }
}
