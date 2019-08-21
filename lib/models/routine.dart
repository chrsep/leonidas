import 'package:flutter/cupertino.dart';
import 'package:leonidas/models/cycle.dart';

import 'session.dart';

enum UnitOfMeasurement { metric, imperial }

// This class defines a full workout routine and progression
// for example we could create 5/3/1 with this class complete with
// week by week and cycle by cycle progression.
class Routine extends ChangeNotifier {
  Routine(this.name, this.sessions, this.unitOfMeasurement, this.trainingMax,
      this.cycle);

  // percentage from repMax use as base
  final int trainingMax;
  final String name;
  final List<Session> sessions;
  final UnitOfMeasurement unitOfMeasurement;
  final Cycle cycle;

  double calculateTMWeight(double oneRepMax) => oneRepMax * trainingMax / 100;
}
