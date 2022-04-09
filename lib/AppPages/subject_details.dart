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
  Future<List<SubjectModel>> _initialize() async{
    subjectList = await SubjectHelper.instance.getAllSubject();
    setState(() {

    });
    return subjectList;
  }
  void addSubject(String subjectName)
  {
    SubjectModel subject = SubjectModel.createNewSubject(subjectName: subjectName);
    SubjectHelper.instance.insertSubject(subject);
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
                    addSubject(subjectName);
                  });
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
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter new subject",
                  ),
                  onChanged: (_){
                    subjectName = _;
                  },
                ),
                Flexible(
                  child: FutureBuilder<List<SubjectModel>>(
                    future: _initialize(),
                    builder: (context,snapshot){
                      if(!snapshot.hasData) return CircularProgressIndicator();
                      else{
                        return ListView.builder(
                          itemCount: subjectList.length,
                          itemBuilder: (context,index){
                            return ListTile(
                              onLongPress: (){
                                showPopUp(subjectList[index]);
                              },
                              title: Text(subjectList[index].subjectName),
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

