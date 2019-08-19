import 'package:flutter/cupertino.dart';
import 'package:leonidas/models/history.dart';
import 'package:leonidas/models/routine.dart';
import 'package:tuple/tuple.dart';

import 'exercise.dart';
import 'exercise_set.dart';

class AppStore extends ChangeNotifier {
  AppStore(this.routines);

  final List<History> histories = [];
  final List<Routine> routines;

  // Progress of our current workout.
  int currentSession = 0;
  int currentCycle = 0;
  int _currentActivity = 0;
  int selectedRoutineIdx = 0;

  set currentActivity(int value) {
    _currentActivity = value;
    notifyListeners();
  }

  int get currentActivity {
    return _currentActivity;
  }

  int get nextDayIdx {
    int modifier = 1;
    if (currentSession + modifier >=
        routines[selectedRoutineIdx].sessions.length) {
      modifier = 0 - currentSession;
    }
    return currentSession + modifier;
  }

  int get nextCycleIdx {
    int modifier = nextDayIdx == currentSession + 1 ? 0 : 1;
    if (currentCycle + modifier >=
        routines[selectedRoutineIdx].progression.cycles.length) {
      modifier = 0 - currentCycle;
    }
    return currentCycle + modifier;
  }

  List<Tuple2<Exercise, ExerciseSet>> get currentSessionExercises {
    final routine = routines[selectedRoutineIdx];
    final exercises = routine.sessions[currentSession].exercises;
    final sets = routine.progression.cycles[currentCycle].sets;
    final List<Tuple2<Exercise, ExerciseSet>> map = [];
    for (var exercise in exercises) {
      for (var set in sets) {
        map.add(Tuple2(exercise, set));
      }
    }
    return map;
  }
}
