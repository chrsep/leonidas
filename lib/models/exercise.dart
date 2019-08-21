import 'package:flutter/cupertino.dart';

// This class tracks exercises that we do (deadlift, squat, etc...)
// and our stat on in such as max rep.
class Exercise extends ChangeNotifier {
  Exercise(this.name, this.description, this.maxRep);

  final String name;
  final String description;

  // repetition x weight
  final Map<int, double> maxRep;

  double get oneRepMax {
    if (maxRep.containsKey(1)) {
      return maxRep[1];
    } else {
      final lowestRep = maxRep.keys
          .reduce((value, element) => value > element ? element : value);

      // Estimated using Matt Brzycki formula
      return maxRep[lowestRep] / (1.0278 - 0.0278 * lowestRep);
    }
  }
}
