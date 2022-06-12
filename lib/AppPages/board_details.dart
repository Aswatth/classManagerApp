import 'package:class_manager/Model/board.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BoardDetails extends StatefulWidget {
  const BoardDetails({Key? key}) : super(key: key);

  @override
  _BoardDetailsState createState() => _BoardDetailsState();
}

class _BoardDetailsState extends State<BoardDetails> {
  List<BoardModel> boardList = [];

  String boardName = '';

  @override
  void initState() {
    super.initState();
    _getBoardDetails();
  }

  _getBoardDetails() async{
    boardList = await BoardHelper.instance.getAllBoard();

    setState(() {

    });
  }
  void addBoard()async {
    Alert(
      context: context,
      content: TextField(
        decoration: InputDecoration(
          hintText: "Enter new board",
        ),
        onChanged: (_){
          boardName = _;
        },
      ),
      buttons: [
        DialogButton(
          onPressed: (){
            BoardModel board = BoardModel.createNewBoard(boardName: boardName);
            BoardHelper.instance.insertBoard(board);
          },
          child: Text("Add board"),
        ),
      ]
    ).show().then((value) {
      _getBoardDetails();
    });
  }
  void showPopUp(BoardModel board) {
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
            _getBoardDetails();
          }),
          DialogButton(child: Text("Delete"), onPressed: (){
            //Delete board (unless some student is part of this board)
            BoardHelper.instance.delete(board);
          }),
        ]
    ).show().then((value){
      _getBoardDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (){
                  addBoard();
                }
            ),
            appBar: AppBar(
              leading: BackButton(
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              title: Text("Board details page"),
            ),
            body: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: boardList.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        onLongPress: (){
                          showPopUp(boardList[index]);
                        },
                        title: Text(boardList[index].boardName),
                      );
                    },
                  )
                ),
              ],
            )
        )
    );
  }
}

