import 'package:flutter/cupertino.dart';

import 'exercise_record.dart';
import 'session.dart';
import 'stage.dart';


class History extends ChangeNotifier {
  DateTime dateTime;
  Session session;
  Stage stage;
  int resPeriod;
  List<ExerciseRecord> records;
}
