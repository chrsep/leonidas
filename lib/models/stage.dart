import 'package:flutter/cupertino.dart';

import 'exercise_set.dart';

// A cycle is a group of session that
class Stage extends ChangeNotifier {
  Stage(this.name, this.sets);

  final String name;
  final List<ExerciseSet> sets;
}
