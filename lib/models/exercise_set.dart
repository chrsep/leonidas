import 'package:flutter/cupertino.dart';

class ExerciseSet extends ChangeNotifier {
  ExerciseSet(
      this.sets, this.reps, this.oneMaxRepPercentage, this.order, this.amrap);

  final int sets;
  final int reps;
  final int oneMaxRepPercentage;
  final int order;
  final bool amrap;
}
