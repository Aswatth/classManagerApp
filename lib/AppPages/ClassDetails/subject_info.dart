import 'package:class_manager/Model/subject.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SubjectInfo extends StatefulWidget {
  const SubjectInfo({Key? key}) : super(key: key);

  @override
  _SubjectInfoState createState() => _SubjectInfoState();
}

class _SubjectInfoState extends State<SubjectInfo> {
  List<SubjectModel> subjectList = [];
  List<bool> isEditing = [];
  late TextEditingController controller;
  String subjectName = "";

  bool isAdding = false;

  Future<void> getSubjectList()async{
    List<SubjectModel> temp = await SubjectHelper.instance.getAllSubject();

    setState(() {
      subjectList = temp;
      isEditing = List.filled(subjectList.length, false);
    });
  }

  addBoard()async{
    SubjectModel subject = SubjectModel.createNewSubject(subjectName: subjectName);
    await SubjectHelper.instance.insertSubject(subject);

    getSubjectList();

    controller.clear();
  }

  updateBoard(SubjectModel board, String newBoardName)async{
    await SubjectHelper.instance.update(board, newBoardName);

    getSubjectList();
    controller.clear();
  }

  deleteBoard(SubjectModel board) async{
    await SubjectHelper.instance.delete(board);

    getSubjectList();
  }

  Widget subjectTextField(){
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
          subjectName = _;
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
      for(int i=0; i< subjectList.length; ++i){
        if(subjectList[i].subjectName == text.toUpperCase()){
          print("$text Already exists");
          return "Already exists";
        }
      }
    }
    return null;
  }

  subjectListWidget(){
    return Column(
      children: [
        isAdding?Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: subjectTextField(),
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
            itemCount: subjectList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: isEditing[index]?
                    subjectTextField():
                    Text(subjectList[index].subjectName),
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
                              updateBoard(subjectList[index],subjectName);
                            }
                          });
                        }
                    ):
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        deleteBoard(subjectList[index]);
                      },
                    ),
                    onLongPress: (){
                      setState(() {
                        //Reset all to false
                        isEditing = List.filled(subjectList.length, false);

                        isEditing[index] = !isEditing[index];
                        if(isEditing[index]){
                          controller.text = subjectList[index].subjectName;
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
    getSubjectList();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          isEditing = List.filled(subjectList.length, false);
        }
      },
      child: MaterialApp(
          home: RefreshIndicator(
            onRefresh: getSubjectList,
            child: Scaffold(
                appBar: AppBar(
                  leading: BackButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  title: Text("Subject info"),
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
                body: subjectListWidget()
            ),
          )
      ),
    );
  }
}

