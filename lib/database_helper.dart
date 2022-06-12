import 'dart:io';
import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
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

  final _dbName = "temp25.db";
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

    return await openDatabase(path,version: _version,onCreate: _onCreate());
  }
  _onCreate()
  {
    //Initializing all table
    StudentHelper.instance;
    ClassHelper.instance;
    BoardHelper.instance;
    SubjectHelper.instance;
    SessionHelper.instance;
  }
}