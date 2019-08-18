import 'package:flutter/cupertino.dart';
import 'package:leonidas/models/history.dart';
import 'package:leonidas/models/routine.dart';

class AppStore extends ChangeNotifier {
  AppStore(this.routines);

  final List<History> histories = [];
  final List<Routine> routines;

  // Progress of our current workout.
  int currentSession = 0;
  int currentCycle = 0;
  int currentExercise = 0;
  int selectedRoutineIdx = 0;

  int get nextDayIdx {
    int modifier = 1;
    if (currentSession + modifier >= routines[selectedRoutineIdx].sessions.length) {
      modifier = 0 - currentSession;
    }
    return currentSession + modifier;
  }

  int get nextCycleIdx {
    int modifier = nextDayIdx == currentSession + 1 ? 0 : 1;
    if (currentCycle + modifier >= routines[selectedRoutineIdx].progression.cycles.length) {
      modifier = 0 - currentCycle;
    }
    return currentCycle + modifier;
  }
}
