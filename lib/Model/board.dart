
import 'package:class_manager/database_helper.dart';

class Board{
  final int? id;
  final String boardName;

  Board.createNewBoard({this.id,required this.boardName})
  {
    _insertRecord(boardName);
  }
  Board({required this.id,required this.boardName});

  factory Board.fromMap(Map<String,dynamic> json) => Board(
    id: json['id'],
    boardName:  json['boardName']
  );

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'boardName':boardName
    };
  }
  void _insertRecord(String boardName)
  {
    String tableName = DatabaseHelper.instance.boardTableName;
    String insertQuery = 'INSERT INTO $tableName (BoardName) VALUES ("$boardName")';
    DatabaseHelper.instance.rawInsert(insertQuery);
  }

  @override
  String toString() {
    return 'Board{id: $id, boardName: $boardName}';
  }
}