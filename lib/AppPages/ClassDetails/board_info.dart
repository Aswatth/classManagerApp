import 'package:class_manager/Model/board.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class BoardInfo extends StatefulWidget {
  const BoardInfo({Key? key}) : super(key: key);

  @override
  _BoardInfoState createState() => _BoardInfoState();
}

class _BoardInfoState extends State<BoardInfo> {

  List<BoardModel> boardList = [];
  List<bool> isEditing = [];
  late TextEditingController controller;
  String boardName = "";
  bool isAdding = false;

  Future<void> getBoardList()async{
     List<BoardModel> temp = await BoardHelper.instance.getAllBoard();

     setState(() {
       boardList = temp;
       isEditing = List.filled(boardList.length, false);
     });
  }

  addBoard()async{
    BoardModel board = BoardModel.createNewBoard(boardName: boardName);
    bool isSuccessful = await BoardHelper.instance.insertBoard(board);

    if(isSuccessful){
      getBoardList();

      controller.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${boardName} added successfully!"),
      ),);
    }
  }

  updateBoard(BoardModel board, String newBoardName)async{
    String oldBoardName = board.boardName;
    bool isSuccessful = await BoardHelper.instance.update(board, newBoardName);

    if(isSuccessful){
      getBoardList();
      controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Updated ${oldBoardName} -> ${newBoardName} successfully!"),
      ),);
    }
  }

  deleteBoard(BoardModel board) async{
    try{
      bool isSuccessful = await BoardHelper.instance.delete(board);
      if(isSuccessful){

        getBoardList();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Deleted ${board.boardName} successfully!"),
        ),);
      }
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Cannot delete ${board.boardName} as some students are present for this board!"),
      ),);
    }
  }

  Widget boardTextField(){
    return TextField(
      autofocus: true,
      controller: controller,
      decoration: InputDecoration(
          errorText: _errorText,
          suffixIcon: IconButton(
            icon: Icon(Icons.clear,color: Colors.grey,size: 15,),
            onPressed: (){
              setState(() {
                controller.clear();
              });
            },
          )
      ),
      onChanged: (_){
        setState(() {
          boardName = _;
        });
      },
    );
  }

  String? get _errorText{
    String text = controller.value.text;

    if(text.isEmpty){
      return "Cannot be empty";
    }
    else {
      for(int i=0; i< boardList.length; ++i){
        if(boardList[i].boardName == text.toUpperCase()){
          print("$text Already exists");
          return "Already exists";
        }
      }
    }
    return null;
  }

  boardListWidget(){
    return Column(
      children: [
        isAdding?Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: boardTextField(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text("Add"),
                  onPressed: (){
                    setState(() {
                      if(_errorText == null){
                        addBoard();
                        isAdding = false;
                      }
                    });
                  },
                ),
                TextButton(
                  child: Text("Cancel"),
                  onPressed: (){
                    setState(() {
                      isAdding = false;
                    });
                  },
                ),
              ],
            ),
            Divider(
              color: Colors.black87,
            )
          ],
        ):Container(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: boardList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: isEditing[index]?
                    boardTextField():
                    Text(boardList[index].boardName),
                    trailing: isEditing[index]?
                    IconButton(
                        icon: Icon(
                          Icons.save,
                          color: _errorText == null?Colors.blueAccent:Colors.grey,
                        ),
                        onPressed: (){
                          setState(() {
                            if(_errorText == null){
                              isEditing[index] = !isEditing[index];
                              updateBoard(boardList[index],boardName);
                            }
                          });
                        }
                    ):
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        deleteBoard(boardList[index]);
                      },
                    ),
                    onLongPress: (){
                      setState(() {
                        //Reset all to false
                        isEditing = List.filled(boardList.length, false);

                        isEditing[index] = !isEditing[index];
                        if(isEditing[index]){
                          controller.text = boardList[index].boardName;
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBoardList();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            isEditing = List.filled(boardList.length, false);
          }
        },
        child: RefreshIndicator(
          onRefresh: getBoardList,
          child: Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                title: Text("Board info"),
                actions: [
                  !isAdding?IconButton(
                    icon: Icon(Icons.add),
                    onPressed: (){
                      setState(() {
                        isAdding = true;
                      });
                    },
                  ):Container()
                ],
              ),
              body: boardListWidget()
          ),
        ),
      ),
    );
  }
}
