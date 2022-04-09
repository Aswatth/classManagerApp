import 'package:class_manager/Model/class.dart';
import 'package:class_manager/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class StudentHelper{
  final String _studentTableName = 'STUDENT';

  //Columns
  final String _id = 'id';
  final String _studentPhoneNumber = 'studentPhoneNumber';
  final String _parentPhoneNumber1 = 'studentPhoneNumber1';
  final String _parentPhoneNumber2 = 'studentPhoneNumber2';
  final String _name = 'name';
  final String _dob = 'dob';
  final String _area = 'area';

  static final StudentHelper instance = StudentHelper._privateConstructor();

  StudentHelper._privateConstructor(){
    _initialize();
  }
  void _initialize()async{
    String _createStudentTable ='''
    CREATE TABLE IF NOT EXISTS $_studentTableName(
    $_id  PRIMARY KEY AUTOINCREMENT,
    $_studentPhoneNumber VARCHAR(10),
    $_parentPhoneNumber1 VARCHAR(10),
    $_parentPhoneNumber2 VARCHAR(10),
    $_name VARCHAR(50),
    $_dob DATETIME,
    $_area VARCHAR(25)    
    )
     ''';

    Database db = await DatabaseHelper.instance.database;
    db.execute(_createStudentTable);
  }

  void insertStudent(StudentModel student)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(_studentTableName,where: '$_studentPhoneNumber = ?',whereArgs: [student.studentPhoneNumber]);

    if(data.isEmpty)
    {
      print(student.toString()+" does not already exists");
      //Insert
      db.insert(_studentTableName, student.toMap());
    }
    else{
      print(student.toString()+" already exists");
    }
  }

  void update(StudentModel student)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newBoardName already exists
    List<Map<String,dynamic>> data = await db.query(_studentTableName,where: '$_id = ?',whereArgs: [student.id]);

    if(data.isNotEmpty){
      db.update(_studentTableName, student.toMap(),where: '$_id = ?',whereArgs: [student.id]);
    }
  }

  void delete(StudentModel student)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newBoardName already exists
    List<Map<String,dynamic>> data = await db.query(_studentTableName,where: '$_id = ?',whereArgs: [student.id]);

    if(data.isNotEmpty) {
      db.delete(_studentTableName,where: '$_id = ?',whereArgs: [student.id]);
    }
  }

  Future<List<StudentModel>> getAllStudent() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(_studentTableName);
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
  String area;

  StudentModel.createNewStudent({
    this.id,
    required this.studentPhoneNumber,
    required this.parentPhoneNumber1,
    this.parentPhoneNumber2,
    required this.name,
    required this.dob,
    required this.area
  });

  StudentModel({
    required this.id,
    required this.studentPhoneNumber,
    required this.parentPhoneNumber1,
    required this.parentPhoneNumber2,
    required this.name,
    required this.dob,
    required this.area,
  });

  factory StudentModel.fromMap(Map<String,dynamic> json) => StudentModel(
      id: json['id'],
      studentPhoneNumber: json['studentPhoneNumber'],
      parentPhoneNumber1: json['parentPhoneNumber1'],
      parentPhoneNumber2: json['parentPhoneNumber2'],
      name:  json['name'],
      dob:  json['dob'],
      area: json['area']

  );

  Map<String,dynamic> toMap(){
    return {
      'id': id,
      'studentPhoneNumber':studentPhoneNumber,
      'parentPhoneNumber1':parentPhoneNumber1,
      'parentPhoneNumber2':parentPhoneNumber2,
      'name':name,
      'dob':dob,
      'area':area
    };
  }

  @override
  String toString() {
    return 'StudentModel{id: $id, name: $name, dob: $dob, studentPhoneNumber: $studentPhoneNumber, parentPhoneNumber1: $parentPhoneNumber1, parentPhoneNumber2: $parentPhoneNumber2, area: $area}';
  }
}