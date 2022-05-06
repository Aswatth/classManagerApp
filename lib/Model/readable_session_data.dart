import 'board.dart';
import 'subject.dart';
import 'class.dart';

class ReadableSessionData{
  SubjectModel subjectModel;
  String sessionSlot;
  String startTime;
  String endTime;

  ReadableSessionData({
    required this.subjectModel,
    required this.sessionSlot,
    required this.startTime,
    required this.endTime});
}