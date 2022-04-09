import 'package:class_manager/Model/board.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BoardDetails extends StatefulWidget {
  const BoardDetails({Key? key}) : super(key: key);

  @override
  _BoardDetailsState createState() => _BoardDetailsState();
}

class _BoardDetailsState extends State<BoardDetails> {
  List<BoardModel> boards = [];

  String boardName = '';
  Future<List<BoardModel>> _initialize() async{
    boards = await BoardHelper.instance.getAllBoard();
    setState(() {

    });
    return boards;
  }
  void addBoard(String boardName)
  {
    BoardModel board = BoardModel.createNewBoard(boardName: boardName);
    BoardHelper.instance.insertBoard(board);
  }
  void showPopUp(BoardModel board)
  {
    String _newBoardName = "";
    Alert(
        context: context,
        title: "Edit Board",
        content: TextField(
          controller: TextEditingController()..text = board.boardName,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (_){
            _newBoardName = _;
          },
        ),
        buttons: [
          DialogButton(child: Text("Update"), onPressed: (){
            //Update with new boardName
            BoardHelper.instance.update(board, _newBoardName);
          }),
          DialogButton(child: Text("Delete"), onPressed: (){
            //Delete board (unless some student is part of this board)
            BoardHelper.instance.delete(board);
          }),
        ]
    ).show();
  }
  @override
  Widget build(BuildContext context) {
    _initialize();
    return MaterialApp(
        home: Scaffold(
            floatingActionButton: TextButton(
                child: Icon(Icons.add),
                onPressed: (){
                  setState(() {
                    addBoard(boardName);
                  });
                }
            ),
            appBar: AppBar(
              leading: BackButton(
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              title: Text("Class details page"),
            ),
            body: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter new board",
                  ),
                  onChanged: (_){
                    boardName = _;
                  },
                ),
                Flexible(
                  child: FutureBuilder<List<BoardModel>>(
                    future: _initialize(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData) return CircularProgressIndicator();
                      else{
                        return ListView.builder(
                          itemCount: boards.length,
                          itemBuilder: (context,index){
                            return ListTile(
                              onLongPress: (){
                                showPopUp(boards[index]);
                              },
                              title: Text(boards[index].boardName),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            )
        )
    );
  }
}

