import 'dart:io';

import 'package:class_manager/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class BackUp extends StatefulWidget {
  const BackUp({Key? key}) : super(key: key);

  @override
  _BackUpState createState() => _BackUpState();
}

class _BackUpState extends State<BackUp> {

  String dbPath = '';
  Directory toStoreDir = Directory("/storage/emulated/0/ClassManagerDB");

  _getPath()async{
    Directory dir = await getApplicationDocumentsDirectory();
    dbPath = dir.path;

    setState(() {
      //print("DB PATH: ${dbPath.toString()}");
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
    _requestPermission();
    
    try{
      File dbFile = File(dbPath+"/${DatabaseHelper.instance.dbName}");
      await toStoreDir.create();
      await dbFile.copy("${toStoreDir.path}/${DatabaseHelper.instance.dbName}");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Backup successful to ${toStoreDir}"),
      ),);

    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Backup unsuccessful!"),
      ),);
    }
  }

  _restoreDB()async{
    _requestPermission();

    try{
      File savedDB = File("${toStoreDir.path}/${DatabaseHelper.instance.dbName}");

      await savedDB.copy(dbPath+"/${DatabaseHelper.instance.dbName}");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Successfully restored!"),
      ),);

    }catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Restore unsuccessfuly!"),
      ),);
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
            Text("Backup location: ${toStoreDir.path}"),
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
