import 'package:class_manager/Model/subject.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SubjectDetails extends StatefulWidget {
  const SubjectDetails({Key? key}) : super(key: key);

  @override
  _SubjectDetailsState createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  List<SubjectModel> subjectList = [];

  String subjectName = '';

  @override
  void initState() {
    super.initState();
    _getSubjectDetails();
  }

  _getSubjectDetails() async{
    subjectList = await SubjectHelper.instance.getAllSubject();

    setState(() {
    });
  }
  void addSubject()
  {
    Alert(
        context: context,
        content: TextField(
          decoration: InputDecoration(
            hintText: "Enter new subject",
          ),
          onChanged: (_){
            subjectName = _;
          },
        ),
        buttons: [
          DialogButton(
            onPressed: (){
              SubjectModel subject = SubjectModel.createNewSubject(subjectName: subjectName);
              SubjectHelper.instance.insertSubject(subject);
            },
            child: Text("Add subject"),
          ),
        ]
    ).show().then((value) {
      _getSubjectDetails();
    });
  }
  void showPopUp(SubjectModel subject)
  {
    String _newSubjectName = "";
    Alert(
        context: context,
        title: "Edit subject",
        content: TextField(
          controller: TextEditingController()..text = subject.subjectName,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (_){
            _newSubjectName = _;
          },
        ),
        buttons: [
          DialogButton(child: Text("Update"), onPressed: (){
            //Update with new subjectName
            SubjectHelper.instance.update(subject, _newSubjectName);
          }),
          DialogButton(child: Text("Delete"), onPressed: (){
            //Delete subject (unless some student is part of this subject)
            SubjectHelper.instance.delete(subject);
          }),
        ]
    ).show().then((value) {
      _getSubjectDetails();
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (){
                  addSubject();
                }
            ),
            appBar: AppBar(
              leading: BackButton(
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              title: Text("Subject details page"),
            ),
            body: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: subjectList.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        onLongPress: (){
                          showPopUp(subjectList[index]);
                        },
                        title: Text(subjectList[index].subjectName),
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

