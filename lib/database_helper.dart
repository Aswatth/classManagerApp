import 'dart:io';
import 'package:class_manager/Model/board.dart';
import 'package:class_manager/Model/class.dart';
import 'package:class_manager/Model/fee.dart';
import 'package:class_manager/Model/performance.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:class_manager/Model/subject.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Model/student_session.dart';

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

  final String dbName = "temp28.db";
  final _version = 1;

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
  Future<Database> _initDB() async
  {
    Directory dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path,dbName);

    Database db =  await openDatabase(path,version: _version,onCreate: _onCreate());
    await db.execute('PRAGMA foreign_keys = ON');
    return db;
  }

  dropDB()async{
    Directory dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path,dbName);
    deleteDatabase(path);
    _initDB();
  }

  _onCreate()
  {
    //Initializing all table
    StudentHelper.instance;
    ClassHelper.instance;
    BoardHelper.instance;
    SubjectHelper.instance;
    SessionHelper.instance;
    StudentSessionHelper.instance;
    FeeHelper.instance;
    PerformanceHelper.instance;
  }
}