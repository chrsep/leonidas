import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/exercise_set.dart';
import 'package:leonidas/models/routine.dart';
import 'package:leonidas/utils/weights.dart';

abstract class ActivityListItem {}

class ExerciseItem extends ActivityListItem {
  ExerciseItem(this.exercise, this.set, this.routine);

  final Exercise exercise;
  final ExerciseSet set;
  final Routine routine;

  double get calculatedWeight {
    return calculateWeight(exercise, routine, set);
  }
}

class RestItem extends ActivityListItem {
  RestItem(this.duration);

  final name = 'Rest';
  final int duration;
}

class HeaderItem extends ActivityListItem {
  HeaderItem(this.value);

  final String value;
}
