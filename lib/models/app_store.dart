import 'package:flutter/cupertino.dart';
import 'package:leonidas/models/history.dart';
import 'package:leonidas/models/routine.dart';

class AppStore extends ChangeNotifier {
  AppStore(this.routines);

  final List<History> histories = [];
  final List<Routine> routines;

  // Progress of our current workout.
  int currentDay = 0;
  int currentCycle = 0;
  int currentExecercise = 0;
  int selectedRoutineIdx = 0;
}
