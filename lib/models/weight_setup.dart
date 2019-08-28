import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  // Pair of plates that we have
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

  WeightSetup calculatePossibleWeight(double targetWeight) {
    final List<int> plateWeights = platePairsWeightValues;
    final List<int> availablePlatePairs = getAvailablePlatePairs();
    final List<int> result = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    var weightLeft = targetWeight - barWeight;
    for (var i = 0; i < availablePlatePairs.length; i++) {
      final pairsNeeded = (weightLeft / plateWeights[i]).floor();
      if (pairsNeeded != 0) {
        result[i] = pairsNeeded > availablePlatePairs[i]
            ? availablePlatePairs[i]
            : pairsNeeded;
        weightLeft -= result[i] * plateWeights[i];
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
      targetWeight.toString() + 'Kg',
      barWeight,
    );
  }

  List<int> getAvailablePlatePairs() => [
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

  final platePairsWeightValues = [50, 40, 30, 20, 10, 5, 4, 3, 2, 1];
  final plateColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.white,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.greenAccent,
    Colors.white,
  ];
}
