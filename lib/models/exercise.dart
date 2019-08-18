import 'package:flutter/cupertino.dart';

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
