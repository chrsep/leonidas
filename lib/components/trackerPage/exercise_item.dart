import 'package:flutter/cupertino.dart';
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

  List<Tuple3<int, int, Color>> get getWeightUsed {
    final calculatedWeight = calculateWeight(exercise, routine, set);
    setupUsed ??= weightSetup.calculatePossibleWeight(calculatedWeight);

    final plateWeights = setupUsed.platePairsWeightValues;
    final plateColors = setupUsed.plateColors;
    final availablePlatePairs = setupUsed.getAvailablePlatePairs();
    final List<Tuple3<int, int, Color>> result = [];
    for (var i = 0; i < plateWeights.length; i++) {
      result
          .add(Tuple3(plateWeights[i], availablePlatePairs[i], plateColors[i]));
    }
    return result;
  }

  @override
  Widget buildWidget(colorIdentifier, {bool showWeights}) {
    return Column(
      children: <Widget>[
        Card(
          color: colorIdentifier == null? LeonidasTheme.whiteTint[4] : LeonidasTheme.primaryColor ,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 88,
                    width: 88,
//                    color: LeonidasTheme.primaryColor,
                    child: Center(
                      child: Text(
                        set.reps.toString() + 'X',
                        style: LeonidasTheme.h4,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          set.name.toUpperCase(),
                          style: LeonidasTheme.overline
                              .apply(color: Colors.white70),
                        ),
                        Text(
                          calculatedWeight.toString().replaceAll('.0', '') +
                              ' KG',
                          style: LeonidasTheme.h5,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Divider(height: 0,),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 16),
                child: Text('PLATES', style: LeonidasTheme.overline.apply(color: Colors.white70),),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: getWeightUsed.where((weights) {
                    return weights.item2 > 0;
                  }).map((weights) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, right: 8.0),
                      child: Chip(
                        elevation: 0,
                        backgroundColor: LeonidasTheme.whiteTint[9],
                        avatar: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: weights.item3, shape: BoxShape.circle),
                            ),
                            Center(
                                child: Text(
                              '2',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )),
                          ],
                        ),
                        label: Text(
                          (weights.item1 / 2.0)
                                  .toString()
                                  .replaceAll('.0', '') +
                              ' KG',
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ],
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
