import 'package:class_manager/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class BoardHelper{
  final String boardTableName = 'BOARD';

  final String _boardName = 'boardName';

  static final BoardHelper instance = BoardHelper._privateConstructor();

  BoardHelper._privateConstructor(){
    _initialize();
  }
  void _initialize()async{
    String createBoardTable ='''
    CREATE TABLE IF NOT EXISTS $boardTableName(
    $_boardName TEXT PRIMARY KEY
    )
     ''';

    Database db = await DatabaseHelper.instance.database;
    db.execute(createBoardTable);

    insertBoard(BoardModel.createNewBoard(boardName: 'CBSE'));
    insertBoard(BoardModel.createNewBoard(boardName: 'STATE'));
    insertBoard(BoardModel.createNewBoard(boardName: 'ICSE'));
  }

  factory BoardHelper()
  {
    return instance;
  }

  insertBoard(BoardModel board)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(boardTableName,where: '$_boardName = ?',whereArgs: [board.boardName.toUpperCase()]);

    if(data.isEmpty)
      {
        board.boardName = board.boardName.toUpperCase();

        //Insert
        db.insert(boardTableName, board.toMap());

        print(board.boardName+" inserted successfully");
      }
    else{
      print(board.boardName+" already exists");
    }
  }

  update(BoardModel board,String newBoardName)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newBoardName already exists
    List<Map<String,dynamic>> data = await db.query(boardTableName,where: '$_boardName = ?',whereArgs: [newBoardName.toUpperCase()]);

    if(data.isEmpty){
      String oldBoardName = board.boardName;
      board.boardName = newBoardName.toUpperCase();
      db.update(boardTableName, board.toMap(),where: '$_boardName = ?',whereArgs: [oldBoardName]);

      print(oldBoardName + " successfully updated to " + newBoardName);
    }else{
      print(newBoardName + " already exists");
    }
  }

  delete(BoardModel board)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newBoardName already exists
    List<Map<String,dynamic>> data = await db.query(boardTableName,where: '$_boardName = ?',whereArgs: [board.boardName.toUpperCase()]);

    if(data.isNotEmpty) {
      db.delete(boardTableName,where: '$_boardName = ?',whereArgs: [board.boardName.toUpperCase()]);
      print(board.toString() + " successfully deleted");
    }
  }

  Future<BoardModel?> getBoard(String boardName)async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(boardTableName,where: '$_boardName = ?',whereArgs: [boardName]);
    if(data.length == 1){
      return BoardModel.fromMap(data[0]);
    }
    return null;
  }

  Future<List<BoardModel>> getAllBoard() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(boardTableName);

    return data.map((json)=> BoardModel.fromMap(json)).toList();
  }
}

class BoardModel{
  String boardName;

  BoardModel.createNewBoard({required this.boardName});

  BoardModel({required this.boardName});

  factory BoardModel.fromMap(Map<String,dynamic> json) => BoardModel(
    boardName:  json['boardName']
  );

  Map<String,dynamic> toMap(){
    return {
      'boardName':boardName
    };
  }

  @override
  String toString() {
    return 'BoardModel{boardName: $boardName}';
  }
}