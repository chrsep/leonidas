import 'package:flutter/cupertino.dart';

import 'cycle.dart';
import 'days.dart';
import 'exercise_record.dart';

class History extends ChangeNotifier {
  DateTime dateTime;
  Days day;
  Cycle cycle;
  int resPeriod;
  List<ExerciseRecord> records;
}
