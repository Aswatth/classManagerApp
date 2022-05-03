import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  factory DatabaseHelper()
  {
    return instance;
  }
  DatabaseHelper._privateConstructor()
  {
    _initDB();
  }

  final _dbName = "temp10.db";
  final _version = 1;

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  Future<Database> _initDB() async
  {
    Directory dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path,_dbName);

    return await openDatabase(path,version: _version);
  }
  void createTable(String query)async
  {
    _database!.execute(query);
  }
  void dropTable(String tableName)async
  {
    _database!.delete(tableName);
  }
  void insert(String tableName,Map<String,dynamic> data)
  {
    //dropTable(tableName);
    _database!.insert(tableName, data);
    //print("$data Inserted");
  }
  void rawInsert(String rawQuery)
  {
    _database!.rawInsert(rawQuery);
  }
  Future<List<Map<String,dynamic>>> readAll(String tableName) async
  {
    List<Map<String,dynamic>> maps = await _database!.query(tableName);
    return maps;
  }
  Future close() async{
    _database!.close();
  }
}