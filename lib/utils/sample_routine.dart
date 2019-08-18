import 'package:leonidas/models/cycle.dart';
import 'package:leonidas/models/days.dart';
import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/exercise_set.dart';
import 'package:leonidas/models/progression.dart';
import 'package:leonidas/models/routine.dart';

Routine generateSampleRoutine() {
  const name = 'Wendler 5/3/1';

  final squat = Exercise('Squat', '', {1: 55});
  final bench = Exercise('Bench', '', {1: 55});
  final deadlift = Exercise('Deadlift', '', {1: 80});
  final press = Exercise('press', '', {1: 35});

  final days = [
    Days('Day 1', 0, [squat, bench]),
    Days('Day 2', 1, [deadlift, press]),
    Days('Day 3', 2, [bench, squat]),
  ];

  final exerciseProgression = {
    squat: 5.0,
    bench: 2.5,
    deadlift: 5.0,
    press: 2.5
  };

  final cycles = [
    Cycle('5/5/5', [
      ExerciseSet(1, 5, 65, 0, false),
      ExerciseSet(1, 5, 75, 1, false),
      ExerciseSet(1, 5, 85, 2, true),
      ExerciseSet(5, 5, 65, 0, false),
    ]),
    Cycle('3/3/3', [
      ExerciseSet(1, 3, 65, 0, false),
      ExerciseSet(1, 3, 75, 1, false),
      ExerciseSet(1, 3, 85, 2, true),
      ExerciseSet(5, 5, 65, 0, false),
    ]),
    Cycle('5/3/1', [
      ExerciseSet(1, 5, 75, 0, false),
      ExerciseSet(1, 3, 85, 1, false),
      ExerciseSet(1, 1, 95, 2, true),
      ExerciseSet(5, 5, 75, 0, false),
    ])
  ];

  final progression = Progression(cycles, exerciseProgression);
  return Routine(name, days, 120, UnitOfMeasurement.metric, 90, progression);
}
