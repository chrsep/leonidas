
import 'package:flutter_test/flutter_test.dart';
import 'package:leonidas/models/countdown_timer.dart';

void main() {
  test('Formatting is correct', () {
    const input = 120;
    final result = secondIntFormat(input);
    expect(result, equals('02:00'));
  });
}