import 'package:flutter/material.dart';
import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/exercise_set.dart';
import 'package:leonidas/models/routine.dart';
import 'package:leonidas/models/weight_setup.dart';
import 'package:leonidas/utils/weights.dart';
import 'package:tuple/tuple.dart';

import '../../leonidas_theme.dart';

abstract class ActivityListItem {
  ActivityListItem(this.name);

  final String name;

  Widget buildWidget(Color colorIdentifier);
}

class ExerciseItem extends ActivityListItem {
  ExerciseItem(this.exercise, this.set, this.routine, this.weightSetup)
      : super(exercise.name);

  final Exercise exercise;
  final ExerciseSet set;
  final Routine routine;
  final WeightSetup weightSetup;
  WeightSetup setupUsed;

  double get calculatedWeight {
    final calculatedWeight = calculateWeight(exercise, routine, set);
    setupUsed ??= weightSetup.calculatePossibleWeight(calculatedWeight);
    return setupUsed.calculateTotalWeight();
  }

  List<Tuple2<int, int>> get getWeightUsed {
    final calculatedWeight = calculateWeight(exercise, routine, set);
    setupUsed ??= weightSetup.calculatePossibleWeight(calculatedWeight);

    final List<int> weightValues = setupUsed.getWeightIntList();
    final List<int> availableWeightPairs = setupUsed.getAvailableWeightList();
    final List<Tuple2<int, int>> result = [];
    for (var i = 0; i < weightValues.length; i++) {
      result.add(Tuple2(weightValues[i], availableWeightPairs[i]));
    }
    return result;
  }

  @override
  Widget buildWidget(
    colorIdentifier,
  ) {
    return Card(
      color: colorIdentifier,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  calculatedWeight.toString() + ' Kg',
                  style: LeonidasTheme.h5,
                ),
                Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(set.sets.toString() + ' Sets'),
                    Text(set.reps.toString() + ' Reps'),
                  ],
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
              child: Row(
                children: getWeightUsed.where((weights) {
                  return weights.item2 > 0;
                }).map((weights) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      elevation: 1,
                      backgroundColor: LeonidasTheme.whiteTint[1],
                      label: Text((weights.item2 * 2).toString() +
                          ' x ' +
                          (weights.item1 / 2.0).toString() +
                          'Kg'),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RestItem extends ActivityListItem {
  RestItem(this.duration, this.exerciseName) : super(exerciseName);

  final String exerciseName;
  final int duration;

  @override
  Widget buildWidget(colorIdentifier) {
    return Card(
      color: colorIdentifier ?? LeonidasTheme.whiteTint[1],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text('Rest'), Text(duration.toString() + 's')],
        ),
      ),
    );
  }
}

class HeaderItem extends ActivityListItem {
  HeaderItem(this.value) : super(value);

  final String value;

  @override
  Widget buildWidget(colorIdentifier) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8),
      child: Center(
        child: Text(
          value.toUpperCase(),
          style: LeonidasTheme.h4,
        ),
      ),
    );
  }
}
