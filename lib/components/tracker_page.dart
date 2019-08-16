import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leonidas/leonidas_theme.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:provider/provider.dart';

class TrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final selectedRoutine = store.routines[store.selectedRoutineIdx];
    final selectedDay = selectedRoutine.days[store.currentDay];
    final selectedCycle =
        selectedRoutine.progression.cycles[store.currentCycle];
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 100),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  bottom: 16,
                  top: 8,
                  right: 8,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Tracker',
                        style: LeonidasTheme.h6,
                      ),
                    ),
                    Icon(
                      Icons.settings,
                      color: Colors.white54,
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16, bottom: 8),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'CURRENT ROUTINE',
                          style: LeonidasTheme.overline,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(selectedRoutine.name,
                              overflow: TextOverflow.clip,
                              style: LeonidasTheme.h3),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: selectedRoutine.progression.cycles.map((value) {
                      final isSelected = value.name == selectedCycle.name;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(value.name),
                          backgroundColor: isSelected
                              ? LeonidasTheme.primaryColor
                              : LeonidasTheme.whiteTint[0],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              side: BorderSide(
                                  color: isSelected
                                      ? LeonidasTheme.primaryColor
                                      : LeonidasTheme.whiteTint[1])),
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    children: selectedRoutine.days.map((value) {
                      final isSelected = value.name == selectedDay.name;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(value.name),
                          backgroundColor: isSelected
                              ? LeonidasTheme.secondaryColor
                              : LeonidasTheme.whiteTint[0],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              side: BorderSide(
                                  color: isSelected
                                      ? LeonidasTheme.secondaryColor
                                      : LeonidasTheme.whiteTint[1])),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Card(
                      child: DataTable(
                        columnSpacing: 24,
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Excercise')),
                          DataColumn(label: Text('Set')),
                          DataColumn(label: Text('Reps')),
                          DataColumn(label: Text('Weight')),
                        ],
                        rows: selectedDay.exercises
                            .map((exercise) {
                              final List<DataRow> rows = [];
                              final int tm = (exercise.maxRep[1] *
                                      selectedRoutine.trainingMax /
                                      100)
                                  .floor();
                              for (var set in selectedCycle.sets) {
                                final weight =
                                    set.oneMaxRepPercentage * tm / 100000;
                                final closestTwoAndAHalf =
                                    (weight / 2.5).floor() * 2.5;
                                final roundedWeight =
                                    weight - closestTwoAndAHalf > 1.25
                                        ? closestTwoAndAHalf + 2.5
                                        : closestTwoAndAHalf;
                                rows.add(DataRow(
                                  cells: [
                                    DataCell(Text(exercise.name)),
                                    DataCell(Text(set.sets.toString())),
                                    DataCell(Text(set.reps.toString())),
                                    DataCell(Text(roundedWeight.toString() + 'kg')),
                                  ],
                                ));
                              }
                              return rows;
                            })
                            .expand((i) => i)
                            .toList(),
                      ),
                      color: LeonidasTheme.whiteTint[1],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
