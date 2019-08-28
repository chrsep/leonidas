import 'package:leonidas/models/stage.dart';
import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/exercise_set.dart';
import 'package:leonidas/models/cycle.dart';
import 'package:leonidas/models/routine.dart';
import 'package:leonidas/models/session.dart';
import 'package:leonidas/models/weight_setup.dart';

Routine generateSampleRoutine() {
  const name = 'Wendler 5/3/1';

  final squat = Exercise('Squat', '', {1: 55});
  final bench = Exercise('Bench', '', {1: 55});
  final deadlift = Exercise('Deadlift', '', {1: 80});
  final press = Exercise('press', '', {1: 35});

  final sessions = [
    Session('Day 1', 0, [squat, bench]),
    Session('Day 2', 1, [deadlift, press]),
    Session('Day 3', 2, [bench, squat]),
  ];

  final exerciseProgression = {
    squat: 5.0,
    bench: 2.5,
    deadlift: 5.0,
    press: 2.5
  };

//  final warmUpCycle = [
//    ExerciseSet(1, 5, 40, 0, false, 60),
//    ExerciseSet(1, 5, 50, 1, false, 60),
//    ExerciseSet(1, 5, 60, 2, true, 60),
//  ];

  final stages = [
    Stage('5/5/5', [
//      ...warmUpCycle,
      ExerciseSet(1, 5, 65, 3, false, 120, 'normal'),
      ExerciseSet(1, 5, 75, 4, false, 120, 'normal'),
      ExerciseSet(1, 5, 85, 5, true, 120, 'amrap'),
      ExerciseSet(5, 5, 65, 6, false, 120, 'fsl'),
    ]),
    Stage('3/3/3', [
//      ...warmUpCycle,
      ExerciseSet(1, 3, 65, 3, false, 120, 'normal'),
      ExerciseSet(1, 3, 75, 4, false, 120, 'normal'),
      ExerciseSet(1, 3, 85, 5, true, 120, 'amrap'),
      ExerciseSet(5, 5, 65, 6, false, 120, 'fsl'),
    ]),
    Stage('5/3/1', [
//      ...warmUpCycle,
      ExerciseSet(1, 5, 75, 3, false, 120, 'normal'),
      ExerciseSet(1, 3, 85, 4, false, 120, 'normal'),
      ExerciseSet(1, 1, 95, 5, true, 120, 'amrap'),
      ExerciseSet(5, 5, 75, 6, false, 120, 'fsl'),
    ])
  ];

  final progression = Cycle(stages, exerciseProgression);
  return Routine(name, sessions, UnitOfMeasurement.metric, 90, progression);
}

WeightSetup generateSampleWeightSetup() {
  return WeightSetup(0, 0, 0, 2, 2, 2, 0, 0, 4, 0, 'Barbell', 9);
}
