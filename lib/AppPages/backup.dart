import 'dart:io';

import 'package:class_manager/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class BackUp extends StatefulWidget {
  const BackUp({Key? key}) : super(key: key);

  @override
  _BackUpState createState() => _BackUpState();
}

class _BackUpState extends State<BackUp> {

  String dbPath = '';
  Directory? externalPath;

  _getPath()async{
    Directory dir = await getApplicationDocumentsDirectory();
    dbPath = dir.path;
    externalPath = await getExternalStorageDirectory();

    setState(() {
      print("DB PATH: ${dbPath.toString()}");
      print("External path: $externalPath");
    });
  }
  
  _requestPermission()async{
    var manageStatus = await Permission.manageExternalStorage.status;
    if(!manageStatus.isGranted){
      await Permission.manageExternalStorage.request();
    }

    var storageStatus = await Permission.storage.status;
    if(!storageStatus.isGranted){
      await Permission.storage.request();
    }
  }

  _backupDB()async{
    //_requestPermission();
    
    try{
      File dbFile = File(dbPath+"/${DatabaseHelper.instance.dbName}");
      Directory? newFolderPath = Directory("/storage/emulated/0/ClassManagerDB");
      await newFolderPath.create();
      await dbFile.copy("/storage/emulated/0/ClassManagerDB/${DatabaseHelper.instance.dbName}");
    }catch(e){
      print("Cannot backup ${e.toString()}");
    }
  }

  _restoreDB()async{
    //_requestPermission();

    try{
      File savedDB = File("/storage/emulated/0/ClassManagerDB/${DatabaseHelper.instance.dbName}");

      await savedDB.copy(dbPath+"/${DatabaseHelper.instance.dbName}");

    }catch(e) {
      print("Cannot backup ${e.toString()}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backup"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("DB Path: $dbPath"),
            Text("External directory: $externalPath"),
            ElevatedButton(onPressed: (){_backupDB();setState(() {});}, child: Text("Backup to local")),
            ElevatedButton(
              child: Text("Restore from local backup"),
              onPressed: (){
                _restoreDB();
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}
