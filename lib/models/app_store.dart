import 'package:flutter/cupertino.dart';
import 'package:leonidas/components/trackerPage/exercise_item.dart';
import 'package:leonidas/models/history.dart';
import 'package:leonidas/models/routine.dart';
import 'package:leonidas/models/session.dart';
import 'package:leonidas/models/weight_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cycle.dart';
import 'exercise.dart';
import 'exercise_set.dart';

class AppStore extends ChangeNotifier {
  AppStore(this.routines, this.weightSetups);

  final List<History> histories = [];
  final List<Routine> routines;
  final List<WeightSetup> weightSetups;

  // Progress of our current workout.
  var _currentSessionIdx = 0;
  var _currentCycleIdx = 2;
  var _currentActivity = 0;
  var currentRoutineIdx = 0;
  var selectedRoutineIdx = 0;
  var _exerciseStarted = false;
  var isLoggingResult = false;
  DateTime _exerciseStartTime;
  DateTime _exerciseStopTime;

  int get currentSessionIdx => _currentSessionIdx;

  set currentSessionIdx(int currentSessionIdx) {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setInt('current_session_idx', currentSessionIdx);
    }).then((onValue) {
      if (onValue) {
        _currentSessionIdx = currentSessionIdx;
      }
    });
    notifyListeners();
  }

  int get currentCycleIdx => _currentCycleIdx;

  set currentCycleIdx(int currentCycleIdx) {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setInt('current_cycle_idx', currentCycleIdx);
    }).then((onValue) {
      if (onValue) {
        _currentCycleIdx = currentCycleIdx;
      }
    });
    notifyListeners();
  }

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

  bool get isExercising => _exerciseStarted;

  set isExercising(bool value) {
    _exerciseStarted = value;
    if (value) {
      exerciseStartTime = DateTime.now();
      exerciseStopTime = null;
    } else {
      exerciseStopTime = DateTime.now();
    }
  }

  int get currentActivity => _currentActivity;

  set currentActivity(int value) {
    _currentActivity = value;
    notifyListeners();
  }

  int get nextSessionIdx {
    int modifier = 1;
    if (currentSessionIdx + modifier >= currentRoutine.sessions.length) {
      modifier = 0 - currentSessionIdx;
    }
    return currentSessionIdx + modifier;
  }

  int get nextCycleIdx {
    int modifier = nextSessionIdx == currentSessionIdx + 1 ? 0 : 1;
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

  Routine get currentRoutine => routines[currentRoutineIdx];

  Cycle get currentCycle => currentRoutine.progression.cycles[currentCycleIdx];

  Session get currentSession => currentRoutine.sessions[currentSessionIdx];

  List<Exercise> get currentExercises =>
      currentRoutine.sessions[currentSessionIdx].exercises;

  List<ExerciseSet> get currentSets =>
      currentRoutine.progression.cycles[currentCycleIdx].sets;

  void moveToNextSession() {
    final nextSessionIdx = this.nextSessionIdx;
    final nextCycleIdx = this.nextCycleIdx;
    if (nextSessionIdx == 0) {
      currentCycleIdx = nextCycleIdx;
    }
    currentSessionIdx = nextSessionIdx;
  }
}
