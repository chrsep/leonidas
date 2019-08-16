import 'package:flutter/cupertino.dart';
import 'package:leonidas/models/progression.dart';

import 'days.dart';

enum UnitOfMeasurement{metric, imperial}
class Routine extends ChangeNotifier {
  Routine(this.name, this.days, this.restPeriod, this.unitOfMeasurement, this.trainingMax, this.progression);

  // percentage from repMax use as base
  final int trainingMax;
  final String name;
  final List<Days> days;
  // Rest in seconds
  final int restPeriod;
  final UnitOfMeasurement unitOfMeasurement;
  final Progression progression;
}