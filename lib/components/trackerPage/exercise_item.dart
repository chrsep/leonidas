import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/exercise_set.dart';

class ExerciseItem {
  ExerciseItem(this.exercise, this.set, this.order);

  final Exercise exercise;
  final ExerciseSet set;
  final int order;
}