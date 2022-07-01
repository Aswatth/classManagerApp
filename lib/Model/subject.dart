import 'package:class_manager/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class SubjectHelper{
  final String subjectTableName = 'SUBJECT';

  final String colSubjectName = 'subjectName';

  static final SubjectHelper instance = SubjectHelper._privateConstructor();

  SubjectHelper._privateConstructor(){
    _initialize();
  }

  void _initialize()async{
    String createSubjectTable ='''
    CREATE TABLE IF NOT EXISTS $subjectTableName(
    $colSubjectName TEXT PRIMARY KEY
    )
     ''';

    Database db = await DatabaseHelper.instance.database;
    db.execute(createSubjectTable);

    insertSubject(SubjectModel.createNewSubject(subjectName: 'SCIENCE'));
    insertSubject(SubjectModel.createNewSubject(subjectName: 'MATHS'));
    insertSubject(SubjectModel.createNewSubject(subjectName: 'TAMIL'));
    insertSubject(SubjectModel.createNewSubject(subjectName: 'COMMERCE'));
    insertSubject(SubjectModel.createNewSubject(subjectName: 'ECONOMICS'));
    insertSubject(SubjectModel.createNewSubject(subjectName: 'ACCOUNTS'));
  }

  factory SubjectHelper()
  {
    return instance;
  }

  Future<bool> insertSubject(SubjectModel subject)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(subjectTableName,where: '$colSubjectName = ?',whereArgs: [subject.subjectName.toUpperCase()]);

    if(data.isEmpty)
    {
      subject.subjectName = subject.subjectName.toUpperCase();
      //Insert
      await db.insert(subjectTableName, subject.toMap());
      print(subject.subjectName+" successfully inserted");
      return true;
    }
    else{
      print(subject.subjectName+" already exists");
      return false;
    }
  }

  Future<bool> update(SubjectModel subject,String newSubjectName)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if new subjectName already exists
    List<Map<String,dynamic>> data = await db.query(subjectTableName,where: '$colSubjectName = ?',whereArgs: [newSubjectName.toUpperCase()]);

    if(data.isEmpty){
      String oldSubjectName = subject.subjectName;
      subject.subjectName = newSubjectName.toUpperCase();
      await db.update(subjectTableName, subject.toMap(),where: '$colSubjectName = ?',whereArgs: [oldSubjectName]);

      print(oldSubjectName + " successfully updated to " + newSubjectName);
      return true;
    }else{
      print(newSubjectName + " already exists");
      return false;
    }
  }

  Future<bool> delete(SubjectModel subject)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    await db.delete(subjectTableName,where: '$colSubjectName = ?',whereArgs: [subject.subjectName.toUpperCase()]);
    print(subject.toString() + " successfully deleted");
    return true;
  }

  Future<SubjectModel?> getSubject(String subjectName)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(subjectTableName,where: '$colSubjectName = ?',whereArgs: [subjectName]);
    if(data.length == 1){
      return SubjectModel.fromMap(data[0]);
    }
    return null;
  }

  Future<List<SubjectModel>> getAllSubject() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(subjectTableName);

    return data.map((json) => SubjectModel.fromMap(json)).toList();
  }

}
class SubjectModel{
  String subjectName;

  SubjectModel.createNewSubject({required this.subjectName});

  SubjectModel({required this.subjectName});

  factory SubjectModel.fromMap(Map<String,dynamic> json) => SubjectModel(
      subjectName:  json['subjectName']
  );

  Map<String,dynamic> toMap(){
    return {
      'subjectName':subjectName
    };
  }

  @override
  String toString() {
    return 'SubjectModel{subjectName: $subjectName}';
  }
}