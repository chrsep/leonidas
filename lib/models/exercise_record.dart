import 'package:flutter/cupertino.dart';

import 'exercise.dart';

class ExerciseRecord extends ChangeNotifier {
  Exercise exercise;
  int time;
  int rep;
  int weight; // in Kg
}
