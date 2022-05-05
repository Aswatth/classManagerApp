import 'readable_session_data.dart';
import 'student.dart';

class CompleteStudentDetail{
  StudentModel studentModel;
  List<ReadableSessionData> sessionList;

  CompleteStudentDetail({
    required this.studentModel,
    required this.sessionList
  });
  addSession(ReadableSessionData sessionData){
    sessionList.add(sessionData);
  }
}