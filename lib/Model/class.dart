import 'package:class_manager/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ClassHelper{
  final String classTableName = 'CLASS';

  final String _className = 'className';

  static final ClassHelper instance = ClassHelper._privateConstructor();

  ClassHelper._privateConstructor(){
    _initialize();
  }

  void _initialize()async{
    String createClassObjTable ='''
    CREATE TABLE IF NOT EXISTS $classTableName(
    $_className TEXT PRIMARY KEY
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

  insertClass(ClassModel classObj)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(classTableName,where: '$_className = ?',whereArgs: [classObj.className.toUpperCase()]);

    if(data.isEmpty)
    {
      classObj.className = classObj.className.toUpperCase();
      //Insert
      db.insert(classTableName, classObj.toMap());
      print(classObj.className+" successfully inserted");
    }
    else{
      print(classObj.className+" already exists");
    }
  }

  update(ClassModel classObj,String newClassName)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if new className already exists
    List<Map<String,dynamic>> data = await db.query(classTableName,where: '$_className = ?',whereArgs: [newClassName.toUpperCase()]);

    if(data.isEmpty){
      String oldClassName = classObj.className;
      classObj.className = newClassName.toUpperCase();
      db.update(classTableName, classObj.toMap(),where: '$_className = ?',whereArgs: [oldClassName]);

      print(oldClassName + " successfully updated to " + newClassName);

    }else{
      print(newClassName + " already exists");
    }
  }

  delete(ClassModel classObj)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if new className already exists
    List<Map<String,dynamic>> data = await db.query(classTableName,where: '$_className = ?',whereArgs: [classObj.className.toUpperCase()]);

    if(data.isNotEmpty) {
      db.delete(classTableName,where: '$_className = ?',whereArgs: [classObj.className.toUpperCase()]);
      print(classObj.toString() + " successfully deleted");
    }
  }

  Future<ClassModel?> getClass(String className)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(classTableName,where: '$_className = ?',whereArgs: [className]);
    if(data.length == 1){
      return ClassModel.fromMap(data[0]);
    }
    return null;
  }

  Future<List<ClassModel>> getAllClass() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> data = await db.query(classTableName);

    return data.map((json) => ClassModel.fromMap(json)).toList();
  }

}
class ClassModel{
  String className;

  ClassModel.createNewClass({required this.className});

  ClassModel({required this.className});

  factory ClassModel.fromMap(Map<String,dynamic> json) => ClassModel(
      className:  json['className']
  );

  Map<String,dynamic> toMap(){
    return {
      'className':className
    };
  }

  @override
  String toString() {
    return 'ClassModel{className: $className}';
  }
}