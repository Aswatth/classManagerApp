import 'package:class_manager/AppPages/SessionPages/add_session.dart';
import 'package:class_manager/Model/fee.dart';
import 'package:class_manager/Model/session.dart';
import 'package:class_manager/Model/student.dart';
import 'package:flutter/material.dart';

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
    await SessionHelper.instance.delete(widget.studentModel.id!, subjectName);

    await FeeHelper.instance.delete(widget.studentModel.id!, subjectName);

    getSession();
  }

  editSession(SessionModel session)async
  {
    List<FeeModel> feeModelList = await FeeHelper.instance.getPendingFee(widget.studentModel.id!, session.subjectName);

    Navigator.push(context, MaterialPageRoute(builder: (context) => EditSession(student: widget.studentModel,session: session, feeModel: feeModelList.first,),)).then((value){
      setState(() {
        getSession();
      });
    });
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
        body: ListView.builder(
          itemCount: _sessionList.length,
          itemBuilder: (context, index){
            SessionModel session = _sessionList[index];
            return ListTile(
              title: Text(session.subjectName),
              subtitle: Text(session.sessionSlot.replaceAll("[", "").replaceAll("]", "")),
              trailing: Text(session.startTime + " - " + session.endTime),
              onTap: (){
                editSession(session);
              },
              onLongPress: (){
                deleteSession(session.subjectName);
              },
            );
          },
        )
      ),
    );
  }
}
