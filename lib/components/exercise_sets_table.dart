import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonidas/models/stage.dart';
import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/routine.dart';
import 'package:leonidas/models/weight_setup.dart';
import 'package:leonidas/utils/weights.dart';

import '../leonidas_theme.dart';

class ExerciseSetsTable extends StatelessWidget {
  const ExerciseSetsTable({Key key, this.stage, this.exercise, this.routine, this.weightSetup})
      : super(key: key);

  final Stage stage;
  final Exercise exercise;
  final Routine routine;
  final WeightSetup weightSetup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 8),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  exercise.name,
                  style: LeonidasTheme.h6.apply(color: Colors.white70),
                ),
              ),
              Text(
                exercise.oneRepMax.toString() + ' Kg Base',
                style:
                    LeonidasTheme.subtitle1Light.apply(color: Colors.white70),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Card(
                color: LeonidasTheme.whiteTint[1],
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Set')),
                    DataColumn(label: Text('Reps')),
                    DataColumn(label: Text('Weight')),
                    DataColumn(label: Text('Rest')),
                  ],
                  rows: stage.sets.map((set) {
                    // TM is training max
                    final calculatedWeight = calculateWeight(exercise, routine, set);
                    final weightUsed = weightSetup.calculatePossibleWeight(calculatedWeight);
                    return DataRow(
                      cells: [
                        DataCell(Text(set.sets.toString())),
                        DataCell(Text(set.reps.toString())),
                        DataCell(Text(weightUsed.calculateTotalWeight().toString() + 'kg')),
                        DataCell(Text(set.rest.toString() + 's')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
