import 'package:flutter_test/flutter_test.dart';
import 'package:leonidas/models/weight_setup.dart';

void main() {
  test('Calculated weight setup is correct', () {
    final weightSetup = WeightSetup(0, 0, 0, 2, 2, 2, 0, 0, 4, 0, 'Barbell', 9);
    final calcuLatedPlates = weightSetup.calculatePossibleWeight(61);

    // Pairs need to be correctly calculated
    expect(calcuLatedPlates.ten, 2);
    expect(calcuLatedPlates.five, 1);
    expect(calcuLatedPlates.one, 1);
    expect(calcuLatedPlates.calculateTotalWeight(), 61);
  });
}
