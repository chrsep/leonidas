import 'package:flutter/cupertino.dart';
import 'package:leonidas/components/trackerPage/exercise_item.dart';
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
  var currentSessionIdx = 0;
  var currentCycleIdx = 2;
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
    if (currentSessionIdx + modifier >=
        currentRoutine.sessions.length) {
      modifier = 0 - currentSessionIdx;
    }
    return currentSessionIdx + modifier;
  }

  int get nextCycleIdx {
    int modifier = nextDayIdx == currentSessionIdx + 1 ? 0 : 1;
    if (currentCycleIdx + modifier >=
        currentRoutine.progression.cycles.length) {
      modifier = 0 - currentCycleIdx;
    }
    return currentCycleIdx + modifier;
  }

  List<ActivityListItem> get currentSessionActivities {
    final List<ActivityListItem> activities = [];
    for (var exercise in currentExercises) {
      activities.add(HeaderItem(exercise.name));
      for (var set in currentSets) {
        activities.add(ExerciseItem(exercise, set, currentRoutine));
        activities.add(RestItem(set.rest, exercise.name));
      }
    }
    return activities;
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

  Routine get currentRoutine => routines[selectedRoutineIdx];

  List<Exercise> get currentExercises =>
      currentRoutine.sessions[currentSessionIdx].exercises;

  List<ExerciseSet> get currentSets =>
      currentRoutine.progression.cycles[currentCycleIdx].sets;
}
