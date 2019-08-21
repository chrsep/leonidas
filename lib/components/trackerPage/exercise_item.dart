import 'package:flutter/material.dart';
import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/exercise_set.dart';
import 'package:leonidas/models/routine.dart';
import 'package:leonidas/utils/weights.dart';

import '../../leonidas_theme.dart';

abstract class ActivityListItem {
  ActivityListItem(this.name);
  
  final String name;
}

class ExerciseItem extends ActivityListItem {
  ExerciseItem(this.exercise, this.set, this.routine) : super(exercise.name);

  final Exercise exercise;
  final ExerciseSet set;
  final Routine routine;

  double get calculatedWeight {
    return calculateWeight(exercise, routine, set);
  }

  Widget buildWidget(
    Color cardColor,
  ) {
    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Flex(
          direction: Axis.horizontal,
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
    );
  }
}

class RestItem extends ActivityListItem {
  RestItem(this.duration, this.exerciseName) : super(exerciseName);

  final String exerciseName;
  final int duration;

  Widget buildWidget(Color cardColor) {
    return Card(
      color: cardColor ?? LeonidasTheme.whiteTint[1],
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

  Widget buildWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          value,
          style: LeonidasTheme.h4,
        ),
      ),
    );
  }
}
