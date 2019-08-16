import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: <Widget>[
                Text(
                  selectedRoutine.name,
                  style: LeonidasTheme.h3,
                  textAlign: TextAlign.left,
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
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      side: BorderSide(
                          color: isSelected
                              ? LeonidasTheme.primaryColor
                              : LeonidasTheme.whiteTint[1])),
                ),
              );
            }).toList(),
          ),
          Row(
            children: selectedRoutine.days
                .map((value) {
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
                })
                .toList(),
          )
        ],
      ),
    );
  }
}
