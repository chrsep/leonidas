double roundWeight(double weight, {double roundTo = 2.5}) {
  final closestTwoAndAHalf = (weight / roundTo).ceil() * roundTo;
  return weight - closestTwoAndAHalf > 1.25
      ? closestTwoAndAHalf +roundTo
      : closestTwoAndAHalf;
}
