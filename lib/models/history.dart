import 'package:flutter/cupertino.dart';

import 'cycle.dart';
import 'exercise_record.dart';
import 'session.dart';

class History extends ChangeNotifier {
  DateTime dateTime;
  Session day;
  Cycle cycle;
  int resPeriod;
  List<ExerciseRecord> records;
}
