import 'package:class_manager/Model/class.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ClassInfo extends StatefulWidget {
  const ClassInfo({Key? key}) : super(key: key);

  @override
  _ClassInfoState createState() => _ClassInfoState();
}

class _ClassInfoState extends State<ClassInfo> {
  List<ClassModel> classList = [];
  List<bool> isEditing = [];
  late TextEditingController controller;
  String className = "";
  bool isAdding = false;
  
  Future<void> getClassList()async{
    List<ClassModel> temp = await ClassHelper.instance.getAllClass();

    setState(() {
      classList = temp;
      isEditing = List.filled(classList.length, false);
    });
  }

  addBoard()async{
    ClassModel classObj = ClassModel.createNewClass(className: className);
    await ClassHelper.instance.insertClass(classObj);

    getClassList();

    controller.clear();
  }

  updateBoard(ClassModel classObj, String newClassName)async{
    await ClassHelper.instance.update(classObj, newClassName);

    getClassList();
    controller.clear();
  }

  deleteBoard(ClassModel classObj) async{
    await ClassHelper.instance.delete(classObj);

    getClassList();
  }

  Widget classTextField(){
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
          className = _;
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
      for(int i=0; i< classList.length; ++i){
        if(classList[i].className == text.toUpperCase()){
          print("$text Already exists");
          return "Already exists";
        }
      }
    }
    return null;
  }

  classListWidget(){
    return Column(
      children: [
        isAdding?Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: classTextField(),
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
              itemCount: classList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: isEditing[index]?
                    classTextField():
                    Text(classList[index].className),
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
                              updateBoard(classList[index],className);
                            }
                          });
                        }
                    ):
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        deleteBoard(classList[index]);
                      },
                    ),
                    onLongPress: (){
                      setState(() {
                        //Reset all to false
                        isEditing = List.filled(classList.length, false);

                        isEditing[index] = !isEditing[index];
                        if(isEditing[index]){
                          controller.text = classList[index].className;
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
    getClassList();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          isEditing = List.filled(classList.length, false);
        }
      },
      child: RefreshIndicator(
        onRefresh: getClassList,
        child: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              title: Text("Class info"),
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
            body: classListWidget()
        ),
      ),
    );
  }
}
