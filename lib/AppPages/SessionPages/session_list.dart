import 'package:class_manager/AppPages/PerformancePages/performance_page.dart';
import 'package:class_manager/AppPages/SessionPages/add_session.dart';
import 'package:class_manager/Model/fee.dart';
import 'package:class_manager/Model/performance.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'edit_session.dart';

class SessionList extends StatefulWidget {
  StudentModel studentModel;
  SessionList({Key? key,required this.studentModel}) : super(key: key);

  @override
  _SessionListState createState() => _SessionListState();
}

class _SessionListState extends State<SessionList> {

  List<SessionModel> _sessionList = [];

  Future<void> getSession()async{
    List<SessionModel> temp = await SessionHelper.instance.getSessionByStudentId(widget.studentModel.id!);

    setState(() {
      _sessionList = temp;
    });
  }

  deleteSession(String subjectName)async{
    bool isSessionDeletionSuccessful = await SessionHelper.instance.delete(widget.studentModel.id!, subjectName);

    bool isFeeDeletionSuccessful = await FeeHelper.instance.delete(widget.studentModel.id!, subjectName);

    bool isPerformanceDeletionSuccessful = await PerformanceHelper.instance.deleteData(widget.studentModel.id!,subjectName);

    if(isSessionDeletionSuccessful && isFeeDeletionSuccessful && isPerformanceDeletionSuccessful){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Session deleted successfully!"),
      ),);
    }

    getSession();
  }

  deleteConfirmation(String subjectName){
    Alert(
        context: context,
        content: Text("Are you sure you want to delete ${subjectName} session?"),
        buttons: [
          DialogButton(
            child: Text("No"),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          DialogButton(
            child: Text("Yes"),
            onPressed: (){
              deleteSession(subjectName);
              Navigator.pop(context);
            },
          )
        ]
    ).show();
  }

  editSession(SessionModel session)async
  {
    List<FeeModel> feeModelList = await FeeHelper.instance.getPendingFee(widget.studentModel.id!, session.subjectName);
    print("Pending fee list: ${feeModelList.length}");
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditSession(student: widget.studentModel,session: session, feeModel: feeModelList.first,),)).then((value){
      setState(() {
        getSession();
      });
    });
  }

  Widget sessionListWidget(){
    return ListView.builder(
      itemCount: _sessionList.length,
      itemBuilder: (context, index){
        SessionModel session = _sessionList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent)
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(session.subjectName),
                  subtitle: Text(session.sessionSlot.replaceAll("[", "").replaceAll("]", "")),
                  trailing: Text("${session.startTime} - ${session.endTime}"),
                  onLongPress: (){
                    editSession(session);
                  },
                ),
                Divider(color: Colors.black87,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PerformancePage(studentModel: widget.studentModel,subjectName: session.subjectName),));
                          },
                          child: Row(
                            children: [
                              Icon(Icons.show_chart),
                              Text("View performance")
                            ],
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: (){
                            deleteConfirmation(session.subjectName);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              Text("Delete session")
                            ],
                          )
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getSession,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text("${widget.studentModel.name} ${widget.studentModel.className} ${widget.studentModel.boardName}"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.more_time),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddSession(student: widget.studentModel),)).then((value){
              setState(() {
                getSession();
              });
            });
          },
        ),
        body: sessionListWidget()
      ),
    );
  }
}
