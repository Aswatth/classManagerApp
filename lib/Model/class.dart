import 'package:class_manager/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ClassHelper{
  final String classTableName = 'CLASS';

  final String id = 'id';
  final String _className = 'className';

  static final ClassHelper instance = ClassHelper._privateConstructor();

  ClassHelper._privateConstructor(){
    _initialize();
  }

  void _initialize()async{
    String createClassObjTable ='''
    CREATE TABLE IF NOT EXISTS $classTableName(
    $id INTEGER PRIMARY KEY AUTOINCREMENT,
    $_className VARCHAR(20)
    )
     ''';

    Database db = await DatabaseHelper.instance.database;
    db.execute(createClassObjTable);

    insertClass(ClassModel.createNewClass(className: 'I'));
    insertClass(ClassModel.createNewClass(className: 'II'));
    insertClass(ClassModel.createNewClass(className: 'III'));
    insertClass(ClassModel.createNewClass(className: 'IV'));
    insertClass(ClassModel.createNewClass(className: 'V'));
    insertClass(ClassModel.createNewClass(className: 'VI'));
    insertClass(ClassModel.createNewClass(className: 'VII'));
    insertClass(ClassModel.createNewClass(className: 'VIII'));
    insertClass(ClassModel.createNewClass(className: 'IX'));
    insertClass(ClassModel.createNewClass(className: 'X'));
    insertClass(ClassModel.createNewClass(className: 'XI'));
    insertClass(ClassModel.createNewClass(className: 'XII'));
  }

  factory ClassHelper()
  {
    return instance;
  }

  void insertClass(ClassModel classObj)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(classTableName,where: '$_className = ?',whereArgs: [classObj.className.toUpperCase()]);

    if(data.isEmpty)
    {
      print(classObj.className+" does not already exists");
      classObj.className = classObj.className.toUpperCase();
      //Insert
      db.insert(classTableName, classObj.toMap());
    }
    else{
      print(classObj.className+" already exists");
    }
  }

  void update(ClassModel classObj,String newClassName)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if new className already exists
    List<Map<String,dynamic>> data = await db.query(classTableName,where: '$_className = ?',whereArgs: [newClassName.toUpperCase()]);

    if(data.isEmpty){
      String oldClassName = classObj.className;
      classObj.className = newClassName.toUpperCase();
      db.update(classTableName, classObj.toMap(),where: '$_className = ?',whereArgs: [oldClassName]);
    }else{
      print(newClassName + " already exists");
    }
  }

  void delete(ClassModel classObj)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if new className already exists
    List<Map<String,dynamic>> data = await db.query(classTableName,where: '$_className = ?',whereArgs: [classObj.className.toUpperCase()]);

    if(data.isNotEmpty) {
      db.delete(classTableName,where: '$_className = ?',whereArgs: [classObj.className.toUpperCase()]);
    }
  }

  Future<int?> getClassId(String className) async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(classTableName,where: '$_className = ?',whereArgs: [className]);
    if(data.length == 1){
      return ClassModel.fromMap(data[0]).id;
    }
    return -1;
  }

  Future<ClassModel?> getClass(int classId)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(classTableName,where: '$id = ?',whereArgs: [classId]);
    if(data.length == 1){
      return ClassModel.fromMap(data[0]);
    }
    return null;
  }

  Future<List<ClassModel>> getAllClass() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(classTableName);
    int dataCount = data.length;

    List<ClassModel> classObjs = [];

    for(int i = 0;i<dataCount;++i) {
      classObjs.add(ClassModel.fromMap(data[i]));
    }
    return classObjs;
  }

}
class ClassModel{
  final int? id;
  String className;

  ClassModel.createNewClass({this.id, required this.className});

  ClassModel({required this.id,required this.className});

  factory ClassModel.fromMap(Map<String,dynamic> json) => ClassModel(
      id: json['id'],
      className:  json['className']
  );

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'className':className
    };
  }

  @override
  String toString() {
    return 'ClassModel{id: $id, className: $className}';
  }
}