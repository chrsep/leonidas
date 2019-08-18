import 'package:flutter/cupertino.dart';

class ExerciseSet extends ChangeNotifier {
  ExerciseSet(
      this.sets, this.reps, this.tmPercentage, this.order, this.amrap);

  final int sets;
  final int reps;
  final int tmPercentage;
  final int order;
  final bool amrap;
}
