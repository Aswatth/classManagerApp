import 'package:class_manager/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class SubjectHelper{
  final String subjectTableName = 'SUBJECT';

  final String id = 'id';
  final String _subjectName = 'subjectName';

  static final SubjectHelper instance = SubjectHelper._privateConstructor();

  SubjectHelper._privateConstructor(){
    _initialize();
  }

  void _initialize()async{
    String createSubjectTable ='''
    CREATE TABLE IF NOT EXISTS $subjectTableName(
    $id INTEGER PRIMARY KEY AUTOINCREMENT,
    $_subjectName VARCHAR(20)
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

  void insertSubject(SubjectModel subject)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(subjectTableName,where: '$_subjectName = ?',whereArgs: [subject.subjectName.toUpperCase()]);

    if(data.isEmpty)
    {
      print(subject.subjectName+" does not already exists");
      subject.subjectName = subject.subjectName.toUpperCase();
      //Insert
      db.insert(subjectTableName, subject.toMap());
    }
    else{
      print(subject.subjectName+" already exists");
    }
  }

  void update(SubjectModel subject,String newSubjectName)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newsubjectName already exists
    List<Map<String,dynamic>> data = await db.query(subjectTableName,where: '$_subjectName = ?',whereArgs: [newSubjectName.toUpperCase()]);

    if(data.isEmpty){
      String oldSubjectName = subject.subjectName;
      subject.subjectName = newSubjectName.toUpperCase();
      db.update(subjectTableName, subject.toMap(),where: '$_subjectName = ?',whereArgs: [oldSubjectName]);
    }else{
      print(newSubjectName + " already exists");
    }
  }

  void delete(SubjectModel subject)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newsubjectName already exists
    List<Map<String,dynamic>> data = await db.query(subjectTableName,where: '$_subjectName = ?',whereArgs: [subject.subjectName.toUpperCase()]);

    if(data.isNotEmpty) {
      db.delete(subjectTableName,where: '$_subjectName = ?',whereArgs: [subject.subjectName.toUpperCase()]);
    }
  }

  Future<List<SubjectModel>> getAllSubject() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(subjectTableName);
    int dataCount = data.length;

    List<SubjectModel> subjects = [];

    for(int i = 0;i<dataCount;++i) {
      subjects.add(SubjectModel.fromMap(data[i]));
    }
    return subjects;
  }

}
class SubjectModel{
  final int? id;
  String subjectName;

  SubjectModel.createNewSubject({this.id, required this.subjectName});

  SubjectModel({required this.id,required this.subjectName});

  factory SubjectModel.fromMap(Map<String,dynamic> json) => SubjectModel(
      id: json['id'],
      subjectName:  json['subjectName']
  );

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'subjectName':subjectName
    };
  }

  @override
  String toString() {
    return 'SubjectModel{id: $id, subjectName: $subjectName}';
  }
}