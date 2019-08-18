import 'package:flutter/cupertino.dart';

import 'exercise.dart';

// This is a workout session plan
class Session extends ChangeNotifier {
  Session(this.name, this.order, this.exercises);

  final String name;
  final int order;
  final List<Exercise> exercises;
}
