import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonidas/models/cycle.dart';
import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/routine.dart';
import 'package:leonidas/utils/weights.dart';

import '../leonidas_theme.dart';

class ExerciseSetsTable extends StatelessWidget {
  const ExerciseSetsTable({Key key, this.cycle, this.exercise, this.routine})
      : super(key: key);

  final Cycle cycle;
  final Exercise exercise;
  final Routine routine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left:8.0, right: 8, bottom: 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  exercise.name,
                  style: LeonidasTheme.h6.apply(color: Colors.white70),
                ),
              ),
              Text(
                '1RM: ' + exercise.oneRepMax.toString() + 'KG',
                style: LeonidasTheme.subtitle1.apply(color: Colors.white70),
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
                  columnSpacing: 24,
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Load (xTM)')),
                    DataColumn(label: Text('Set')),
                    DataColumn(label: Text('Reps')),
                    DataColumn(label: Text('Weight')),
                  ],
                  rows: cycle.sets.map((set) {
                    // TM is training max
                    final tmWeight = routine.calculateTMWeight(exercise.oneRepMax);
                    final weight = set.tmPercentage * tmWeight / 100;
                    final roundedWeight = roundWeight(weight);
                    return DataRow(
                      cells: [
                        DataCell(
                            Text(set.tmPercentage.toString() + '%')),
                        DataCell(Text(set.sets.toString())),
                        DataCell(Text(set.reps.toString())),
                        DataCell(Text(roundedWeight.toString() + 'kg')),
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
