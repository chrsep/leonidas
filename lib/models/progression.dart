import 'package:flutter/cupertino.dart';
import 'package:leonidas/models/exercise.dart';

import 'cycle.dart';

class Progression extends ChangeNotifier {
  Progression(this.cycles, this.exerciseWeightPrograssion);

  final List<Cycle> cycles;
  // How many weight should be added to rep max when progressing
  final Map<Exercise, int> exerciseWeightPrograssion;
}
