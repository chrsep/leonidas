import 'package:flutter/cupertino.dart';

import 'stage.dart';
import 'exercise_record.dart';
import 'session.dart';

class History extends ChangeNotifier {
  DateTime dateTime;
  Session day;
  Stage cycle;
  int resPeriod;
  List<ExerciseRecord> records;
}
