import 'package:leonidas/models/cycle.dart';
import 'package:leonidas/models/days.dart';
import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/exercise_set.dart';
import 'package:leonidas/models/progression.dart';
import 'package:leonidas/models/routine.dart';

Routine generateSampleRoutine() {
  const name = 'Wendler 5/3/1';

  final squat = Exercise('Squat', '', {1: 55000});
  final bench = Exercise('Bench', '', {1: 35000});
  final deadlift = Exercise('Deadlift', '', {1: 80000});
  final press = Exercise('press', '', {1: 35000});

  final days = [
    Days('Day 1', 0, [squat, bench]),
    Days('Day 2', 1, [deadlift, press]),
    Days('Day 3', 2, [bench, squat]),
  ];

  final exerciseProgression = {
    squat: 5000,
    bench: 2500,
    deadlift: 5000,
    press: 2500
  };

  final cycles = [
    Cycle('5/5/5', [
      ExerciseSet(5, 65, 0),
      ExerciseSet(5, 75, 1),
      ExerciseSet(5, 85, 2),
    ]),
    Cycle('3/3/3', [
      ExerciseSet(5, 65, 0),
      ExerciseSet(5, 75, 1),
      ExerciseSet(5, 85, 2),
    ]),
    Cycle('5/3/1', [
      ExerciseSet(5, 65, 0),
      ExerciseSet(5, 75, 1),
      ExerciseSet(5, 85, 2),
    ])
  ];

  final progression = Progression(cycles, exerciseProgression);
  return Routine(name, days, 120, UnitOfMeasurement.metric, 90, progression);
}
