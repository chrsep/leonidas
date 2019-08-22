import 'package:flutter/cupertino.dart';
import 'package:leonidas/components/trackerPage/exercise_item.dart';
import 'package:leonidas/models/history.dart';
import 'package:leonidas/models/routine.dart';
import 'package:leonidas/models/session.dart';
import 'package:leonidas/models/weight_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'exercise.dart';
import 'exercise_set.dart';
import 'stage.dart';

class AppStore extends ChangeNotifier {
  AppStore(this.routines, this.weightSetups);

  final List<History> histories = [];
  final List<Routine> routines;
  final List<WeightSetup> weightSetups;

  // Progress of our current workout.
  final _currentWeightSetupIdx = 0;
  var _currentSessionIdx = 0;
  var _currentStageIdx = 2;
  var _currentActivityIdx = 0;
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

  int get currentStageIdx => _currentStageIdx;

  set currentStageIdx(int currentStageIdx) {
    SharedPreferences.getInstance().then((prefs) {
      return prefs.setInt('current_stage_idx', currentStageIdx);
    }).then((onValue) {
      if (onValue) {
        _currentStageIdx = currentStageIdx;
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

  int get currentActivityIdx => _currentActivityIdx;

  set currentActivityIdx(int value) {
    _currentActivityIdx = value;
    notifyListeners();
  }

  int get nextSessionIdx {
    int modifier = 1;
    if (currentSessionIdx + modifier >= currentRoutine.sessions.length) {
      modifier = 0 - currentSessionIdx;
    }
    return currentSessionIdx + modifier;
  }

  int get nextStageIdx {
    int modifier = nextSessionIdx == currentSessionIdx + 1 ? 0 : 1;
    if (currentStageIdx + modifier >= currentRoutine.cycle.stages.length) {
      modifier = 0 - currentStageIdx;
    }
    return currentStageIdx + modifier;
  }

  List<ActivityListItem> get currentSessionActivities {
    final List<ActivityListItem> activities = [];
    for (var exercise in currentExercises) {
      activities.add(HeaderItem(exercise.name));
      for (var set in currentSets) {
        activities.add(
            ExerciseItem(exercise, set, currentRoutine, currentWeightSetup));
        activities.add(RestItem(set.rest, exercise.name));
      }
    }
    return activities;
  }

  Routine get currentRoutine => routines[currentRoutineIdx];

  Stage get currentStage => currentRoutine.cycle.stages[currentStageIdx];

  Session get currentSession => currentRoutine.sessions[currentSessionIdx];

  WeightSetup get currentWeightSetup => weightSetups[_currentWeightSetupIdx];

  List<Exercise> get currentExercises =>
      currentRoutine.sessions[currentSessionIdx].exercises;

  List<ExerciseSet> get currentSets =>
      currentRoutine.cycle.stages[currentStageIdx].sets;

  void moveToNextSession() {
    final nextSessionIdx = this.nextSessionIdx;
    final nextStageIdx = this.nextStageIdx;
    if (nextSessionIdx == 0) {
      currentStageIdx = nextStageIdx;
    }
    currentSessionIdx = nextSessionIdx;
  }
}
