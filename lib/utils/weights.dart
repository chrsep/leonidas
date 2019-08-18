import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/exercise_set.dart';
import 'package:leonidas/models/routine.dart';

double roundWeight(double weight, {double roundTo = 2.5}) {
  final closestTwoAndAHalf = (weight / roundTo).ceil() * roundTo;
  return weight - closestTwoAndAHalf > 1.25
      ? closestTwoAndAHalf +roundTo
      : closestTwoAndAHalf;
}

double calculateWeight(Exercise exercise, Routine routine, ExerciseSet set) {
  final tmWeight = routine.calculateTMWeight(exercise.oneRepMax);
  final weight = set.tmPercentage * tmWeight / 100;
  return roundWeight(weight);
}