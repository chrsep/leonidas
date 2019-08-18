import 'package:flutter/cupertino.dart';
import 'package:leonidas/models/progression.dart';

import 'session.dart';

enum UnitOfMeasurement { metric, imperial }

class Routine extends ChangeNotifier {
  Routine(this.name, this.sessions, this.unitOfMeasurement, this.trainingMax,
      this.progression);

  // percentage from repMax use as base
  final int trainingMax;
  final String name;
  final List<Session> sessions;
  final UnitOfMeasurement unitOfMeasurement;
  final Progression progression;

  double calculateTMWeight(double oneRepMax) => oneRepMax * trainingMax / 100;
}
