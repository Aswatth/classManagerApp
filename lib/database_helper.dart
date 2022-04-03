import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:class_manager/Model/board.dart';

class DatabaseHelper{

  DatabaseHelper._privateConstructor()
  {
    _initDB();
  }
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  final _dbName = "temp2.db";
  final _version = 1;

  String boardTableName = 'BOARD';

  static Database? _database;

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  Future<Database> _initDB() async
  {
    Directory dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path,_dbName);

    _database = await openDatabase(path,version: _version);

    String createBoardTable ='''
CREATE TABLE IF NOT EXISTS $boardTableName(
id INTEGER PRIMARY KEY AUTOINCREMENT,
boardName VARCHAR(20)
)
 ''';
    createTable(createBoardTable);

    return _database!;
  }
  void createTable(String query)async
  {
    _database ??= await _initDB();
    _database!.execute(query);
    //print("Table created");
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
    Future<int> id = _database!.rawInsert(rawQuery);
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