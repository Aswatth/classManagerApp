import 'package:class_manager/Model/class.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ClassDetails extends StatefulWidget {
  const ClassDetails({Key? key}) : super(key: key);

  @override
  _ClassDetailsState createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  List<ClassModel> classList = [];

  String className = '';

  @override
  void initState() {
    _getClassDetails();
  }

  _getClassDetails() async{
    classList = await ClassHelper.instance.getAllClass();

    setState(() {
    });
    return classList;
  }
  void addClass() {
    Alert(
      context: context,
      content: TextField(
        decoration: InputDecoration(
          hintText: "Enter new class",
        ),
        onChanged: (_){
          className = _;
        },
      ),
      buttons: [
        DialogButton(
            child: Text("Add class"),
            onPressed: (){
              ClassModel classObj = ClassModel.createNewClass(className: className);
              ClassHelper.instance.insertClass(classObj);
        })
      ]
    ).show().then((value) {
      _getClassDetails();
    });
  }
  void showPopUp(ClassModel classObj) {
    String _newClassName = "";
    Alert(
        context: context,
        title: "Edit class",
        content: TextField(
          controller: TextEditingController()..text = classObj.className,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (_){
            _newClassName = _;
          },
        ),
        buttons: [
          DialogButton(child: Text("Update"), onPressed: (){
            //Update with new className
            ClassHelper.instance.update(classObj, _newClassName);
          }),
          DialogButton(child: Text("Delete"), onPressed: (){
            //Delete class (unless some student is part of this class)
            ClassHelper.instance.delete(classObj);
          }),
        ]
    ).show().then((value) {
      _getClassDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (){
                  setState(() {
                    addClass();
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

                Flexible(
                  child: ListView.builder(
                    itemCount: classList.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        onLongPress: (){
                          showPopUp(classList[index]);
                        },
                        title: Text(classList[index].className),
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

