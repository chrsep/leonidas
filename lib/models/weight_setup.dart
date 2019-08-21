import 'package:flutter/cupertino.dart';

class WeightSetup extends ChangeNotifier {
  WeightSetup(
      this.twentyFive,
      this.twenty,
      this.fifteen,
      this.ten,
      this.five,
      this.twoAndAHalf,
      this.two,
      this.oneAndAHalf,
      this.one,
      this.half,
      this.name,
      this.barWeight);

  final String name;
  final int barWeight;
  final int twentyFive;
  final int twenty;
  final int fifteen;
  final int ten;
  final int five;
  final int twoAndAHalf;
  final int two;
  final int oneAndAHalf;
  final int one;
  final int half;

  double calculateTotalWeight() {
    return barWeight +
        twentyFive * 50.0 +
        twenty * 40.0 +
        fifteen * 30.0 +
        ten * 20.0 +
        five * 10.0 +
        twoAndAHalf * 5 +
        two * 4.0 +
        oneAndAHalf * 3 +
        one * 2.0 +
        half * 1.0;
  }

  WeightSetup calculatePossibleWeight(double weight) {
    final List<int> weightValues = getWeightIntList();
    final List<int> availableWeightPairs = getAvailableWeightList();
    final List<int> result = [0, 0, 0, 0, 0, 0, 0, 0, 0,0];

    var weightLeft = weight - barWeight;
    for (var i = 0; i < availableWeightPairs.length; i++) {
      final pairsNeeded = (weightLeft / weightValues[i]).floor();
      if (pairsNeeded != 0) {
        result[i] = pairsNeeded > availableWeightPairs[i]
            ? availableWeightPairs[i]
            : pairsNeeded;
        weightLeft -= result[i] * weightValues[i];
      }
    }
    return WeightSetup(
      result[0],
      result[1],
      result[2],
      result[3],
      result[4],
      result[5],
      result[6],
      result[7],
      result[8],
      result[9],
      weight.toString() + 'Kg',
      barWeight,
    );
  }

  List<int> getAvailableWeightList() {
    return [
      twentyFive,
      twenty,
      fifteen,
      ten,
      five,
      twoAndAHalf,
      two,
      oneAndAHalf,
      one,
      half
    ];
  }

  List<int> getWeightIntList() {
    return [50, 40, 30, 20, 10, 5, 4, 3, 2, 1];
  }
}
