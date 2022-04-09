import 'package:class_manager/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class BoardHelper{
  final String _boardTableName = 'BOARD';

  final String _id = 'id';
  final String _boardName = 'boardName';

  static final BoardHelper instance = BoardHelper._privateConstructor();

  BoardHelper._privateConstructor(){
    _initialize();
  }
  void _initialize()async{
    String createBoardTable ='''
    CREATE TABLE IF NOT EXISTS $_boardTableName(
    $_id INTEGER PRIMARY KEY AUTOINCREMENT,
    $_boardName VARCHAR(20)
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

  void insertBoard(BoardModel board)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if it already exists
    List<Map<String,dynamic>> data = await db.query(_boardTableName,where: '$_boardName = ?',whereArgs: [board.boardName.toUpperCase()]);

    if(data.isEmpty)
      {
        print(board.boardName+" does not already exists");
        board.boardName = board.boardName.toUpperCase();
        //Insert
        db.insert(_boardTableName, board.toMap());
      }
    else{
      print(board.boardName+" already exists");
    }
  }

  void update(BoardModel board,String newBoardName)async {
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newBoardName already exists
    List<Map<String,dynamic>> data = await db.query(_boardTableName,where: '$_boardName = ?',whereArgs: [newBoardName.toUpperCase()]);

    if(data.isEmpty){
      String oldBoardName = board.boardName;
      board.boardName = newBoardName;
      db.update(_boardTableName, board.toMap(),where: '$_boardName = ?',whereArgs: [oldBoardName]);
    }else{
      print(newBoardName + " already exists");
    }
  }

  void delete(BoardModel board)async{
    //GET DB
    Database db = await DatabaseHelper.instance.database;

    //Check if newBoardName already exists
    List<Map<String,dynamic>> data = await db.query(_boardTableName,where: '$_boardName = ?',whereArgs: [board.boardName.toUpperCase()]);

    if(data.isNotEmpty) {
      db.delete(_boardTableName,where: '$_boardName = ?',whereArgs: [board.boardName.toUpperCase()]);
    }
  }

  Future<List<BoardModel>> getAllBoard() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String,dynamic>> data = await db.query(_boardTableName);
    int dataCount = data.length;

    List<BoardModel> boards = [];

    for(int i = 0;i<dataCount;++i) {
      boards.add(BoardModel.fromMap(data[i]));
    }
    return boards;
  }
}

class BoardModel{
  final int? id;
  String boardName;

  BoardModel.createNewBoard({this.id,required this.boardName});

  BoardModel({required this.id,required this.boardName});

  factory BoardModel.fromMap(Map<String,dynamic> json) => BoardModel(
    id: json['id'],
    boardName:  json['boardName']
  );

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'boardName':boardName
    };
  }

  @override
  String toString() {
    return 'BoardModel{id: $id, boardName: $boardName}';
  }
}