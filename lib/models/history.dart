import 'package:flutter/cupertino.dart';

import 'cycle.dart';
import 'session.dart';
import 'exercise_record.dart';

class History extends ChangeNotifier {
  DateTime dateTime;
  Session day;
  Cycle cycle;
  int resPeriod;
  List<ExerciseRecord> records;
}
