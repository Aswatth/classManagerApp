import 'package:class_manager/Model/class.dart';
import 'package:class_manager/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class StudentHelper{
  final String studentTableName = 'STUDENT';

  //Columns
  final String id = 'id';
  final String _studentPhoneNumber = 'studentPhoneNumber';
  final String _parentPhoneNumber1 = 'parentPhoneNumber1';
  final String _parentPhoneNumber2 = 'parentPhoneNumber2';
  final String _name = 'name';
  final String _dob = 'dob';
  final String _location = 'location';

  static final StudentHelper instance = StudentHelper._privateConstructor();

  StudentHelper._privateConstructor(){
    _initialize();
  }
  void _initialize()async{
    String _createStudentTable ='''
    CREATE TABLE IF NOT EXISTS $studentTableName(
    $id  INTEGER PRIMARY KEY AUTOINCREMENT,
    $_studentPhoneNumber VARCHAR(10),
    $_parentPhoneNumber1 VARCHAR(10),
    $_parentPhoneNumber2 VARCHAR(10),
    $_name VARCHAR(50),
    $_dob VARCHAR(25),
    $_location VARCHAR(25)    
    )
     ''';

    Database db = await DatabaseHelper.instance.database;
    db.execute(_createStudentTable);
  }

  Future<int> insertStudent(StudentModel student)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$_studentPhoneNumber = ? or $_parentPhoneNumber1 = ?',whereArgs: [student.studentPhoneNumber,student.parentPhoneNumber1]);

    if(data.isEmpty)
    {
      print(student.toString()+" does not already exists");
      //Insert
      return db.insert(studentTableName, student.toMap());
    }
    else{
      print(student.toString()+" already exists");
      return -1;
    }
  }

  void update(StudentModel student)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newBoardName already exists
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$id = ?',whereArgs: [student.id]);

    if(data.isNotEmpty){
      db.update(studentTableName, student.toMap(),where: '$id = ?',whereArgs: [student.id]);
    }
  }

  void delete(StudentModel student)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newBoardName already exists
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$id = ?',whereArgs: [student.id]);

    if(data.isNotEmpty) {
      db.delete(studentTableName,where: '$id = ?',whereArgs: [student.id]);
    }
  }

  Future<StudentModel?> getStudent(int studentId)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(studentTableName,where: '$id = ?',whereArgs: [studentId]);
    if(data.length == 1){
      return StudentModel.fromMap(data[0]);
    }
    return null;
  }

  Future<List<StudentModel>> getAllStudent() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(studentTableName);
    int dataCount = data.length;

    List<StudentModel> students = [];

    for(int i = 0;i<dataCount;++i) {
      students.add(StudentModel.fromMap(data[i]));
    }
    return students;
  }
}

class StudentModel{
  int? id;
  String studentPhoneNumber;
  String parentPhoneNumber1;
  String? parentPhoneNumber2;
  String name;
  DateTime dob;
  String location;

  StudentModel.createNewStudent({
    this.id,
    required this.studentPhoneNumber,
    required this.parentPhoneNumber1,
    this.parentPhoneNumber2,
    required this.name,
    required this.dob,
    required this.location
  });

  StudentModel({
    required this.id,
    required this.studentPhoneNumber,
    required this.parentPhoneNumber1,
    required this.parentPhoneNumber2,
    required this.name,
    required this.dob,
    required this.location,
  });

  factory StudentModel.fromMap(Map<String,dynamic> json) => StudentModel(
      id: json['id'],
      studentPhoneNumber: json['studentPhoneNumber'],
      parentPhoneNumber1: json['parentPhoneNumber1'],
      parentPhoneNumber2: json['parentPhoneNumber2'],
      name:  json['name'],
      dob:  DateFormat('dd-MMM-yyyy').parse(json['dob']),
      location: json['location']

  );

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'studentPhoneNumber':studentPhoneNumber,
      'parentPhoneNumber1':parentPhoneNumber1,
      'parentPhoneNumber2':parentPhoneNumber2,
      'name':name,
      'dob':DateFormat('dd-MMM-yyyy').format(dob).toString(),
      'location':location
    };
  }

  @override
  String toString() {
    return 'StudentModel{id: $id, name: $name, dob: $dob, studentPhoneNumber: $studentPhoneNumber, parentPhoneNumber1: $parentPhoneNumber1, parentPhoneNumber2: $parentPhoneNumber2, location: $location}';
  }
}