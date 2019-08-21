import 'package:flutter/cupertino.dart';
import 'package:leonidas/models/exercise.dart';

import 'stage.dart';

class Cycle extends ChangeNotifier {
  Cycle(this.stages, this.exerciseWeightProgression);

  final List<Stage> stages;
  // How many weight should be added to rep max when progressing
  final Map<Exercise, double> exerciseWeightProgression;
}
