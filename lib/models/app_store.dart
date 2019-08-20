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
  var currentSession = 0;
  var currentCycle = 2;
  var _currentActivity = 0;
  var selectedRoutineIdx = 0;
  var _exerciseStarted = false;
  var isLoggingResult = false;

  DateTime _exerciseStartTime;
  DateTime _exerciseStopTime;

  DateTime get exerciseStopTime => _exerciseStopTime;

  set exerciseStopTime(DateTime exerciseStopTime) {
    _exerciseStopTime = exerciseStopTime;
    notifyListeners();
  }

  DateTime get exerciseStartTime => _exerciseStartTime;

  set exerciseStartTime(DateTime exerciseStartTime) {
    _exerciseStartTime = exerciseStartTime;
    notifyListeners();
  }

  set isExercising(bool value) {
    _exerciseStarted = value;
    if (value) {
      exerciseStartTime = DateTime.now();
      exerciseStopTime = null;
    } else {
      exerciseStopTime = DateTime.now();
    }
    notifyListeners();
  }

  bool get isExercising {
    return _exerciseStarted;
  }

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

  void startExercise() {
    currentActivity = 0;
  }

  void finishWorkout() {
    isLoggingResult = true;
    isExercising = false;
  }

  void finishLogging() {
    isLoggingResult = false;
  }

  void cancelExercise() {
    isExercising = false;
  }
}
