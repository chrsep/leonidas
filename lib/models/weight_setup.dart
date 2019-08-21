import 'package:flutter/cupertino.dart';

class WeightSetup extends ChangeNotifier {
  WeightSetup(this.twentyFive, this.twenty, this.fifteen, this.ten, this.five,
      this.twoAndAHalf, this.two, this.oneAndAHalf, this.one, this.half, this.name, this.barWeight);

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
}
