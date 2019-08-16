import 'package:flutter/cupertino.dart';

import 'exercise_set.dart';

class Cycle extends ChangeNotifier {
  Cycle(this.name, this.sets);

  final String name;
  final List<ExerciseSet> sets;
}
