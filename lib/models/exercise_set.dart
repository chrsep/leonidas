import 'package:flutter/cupertino.dart';

class ExerciseSet extends ChangeNotifier {
  ExerciseSet(this.reps, this.oneMaxRepPercentage, this.order);

  final int reps;
  final int oneMaxRepPercentage;
  final int order;
}
