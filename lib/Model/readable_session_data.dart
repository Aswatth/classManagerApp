import 'board.dart';
import 'subject.dart';
import 'class.dart';

class ReadableSessionData{
  ClassModel classModel;
  SubjectModel subjectModel;
  BoardModel boardModel;
  String sessionSlot;
  String startTime;
  String endTime;

  ReadableSessionData({
    required this.classModel,
    required this.subjectModel,
    required this.boardModel,
    required this.sessionSlot,
    required this.startTime,
    required this.endTime});
}