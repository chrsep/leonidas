import 'package:flutter/cupertino.dart';

import 'exercise.dart';

class Days extends ChangeNotifier {
  Days(this.name, this.order, this.exercises);

  final String name;
  final int order;
  final List<Exercise> exercises;
}
