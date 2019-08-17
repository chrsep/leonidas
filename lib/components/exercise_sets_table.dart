import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonidas/models/cycle.dart';
import 'package:leonidas/models/exercise.dart';
import 'package:leonidas/models/routine.dart';

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
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8.0),
      child: Column(children: [
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                exercise.name,
                style: LeonidasTheme.h6,
              ),
            )
          ],
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
                    final int tm =
                        (exercise.maxRep[1] * routine.trainingMax / 100)
                            .floor();
                    final weight = set.oneMaxRepPercentage * tm / 100000;
                    final closestTwoAndAHalf = (weight / 2.5).floor() * 2.5;
                    final roundedWeight = weight - closestTwoAndAHalf > 1.25
                        ? closestTwoAndAHalf + 2.5
                        : closestTwoAndAHalf;
                    return DataRow(
                      cells: [
                        DataCell(
                            Text(set.oneMaxRepPercentage.toString() + '%')),
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
