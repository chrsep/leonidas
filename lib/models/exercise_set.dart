import 'package:flutter/cupertino.dart';

class ExerciseSet extends ChangeNotifier {
  ExerciseSet(
    this.sets,
    this.reps,
    this.tmPercentage,
    this.order,
    this.amrap,
    this.rest,
    this.name,
  );

  final String name;
  final int sets;
  final int reps;
  final int tmPercentage;
  final int order;
  final bool amrap;

  // rest period in seconsds
  final int rest;
}
