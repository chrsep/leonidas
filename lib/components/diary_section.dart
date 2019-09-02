import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leonidas/components/exercise_sets_table.dart';
import 'package:leonidas/leonidas_theme.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:provider/provider.dart';

class DiarySection extends StatefulWidget {
  @override
  _DiarySectionState createState() => _DiarySectionState();
}

class _DiarySectionState extends State<DiarySection> {
  bool isShowingNext;

  @override
  void initState() {
    isShowingNext = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final selectedRoutine = store.routines[store.currentRoutineIdx];
    final selectedDay = selectedRoutine.sessions[
        isShowingNext ? store.nextSessionIdx : store.currentSessionIdx];
    final selectedStage = selectedRoutine.cycle
        .stages[isShowingNext ? store.nextStageIdx : store.currentStageIdx];
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
                        'Diary',
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
              padding: const EdgeInsets.only(left: 8.0, top: 16, bottom: 0),
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
                        Flexible(
                          child: Text(selectedRoutine.name,
                              overflow: TextOverflow.clip,
                              style: LeonidasTheme.h2),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'WORKOUT CYCLE',
                        style: LeonidasTheme.overline,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => setState(() => {isShowingNext = false}),
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 200),
                            child: Text('Current'),
                            style: LeonidasTheme.h4.apply(
                              color: isShowingNext
                                  ? Colors.white30
                                  : LeonidasTheme.accentColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: GestureDetector(
                            onTap: () => setState(() => {isShowingNext = true}),
                            child: AnimatedDefaultTextStyle(
                              curve: Curves.ease,
                              child: Text('Next'),
                              duration: Duration(milliseconds: 200),
                              style: LeonidasTheme.h4.apply(
                                color: isShowingNext
                                    ? LeonidasTheme.accentColor
                                    : Colors.white30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: selectedRoutine.cycle.stages.map((value) {
                      final isSelected = value.name == selectedStage.name;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(value.name),
                          backgroundColor: LeonidasTheme.whiteTint[0],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? LeonidasTheme.blue
                                  : LeonidasTheme.whiteTint[1],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    children: selectedRoutine.sessions.map((value) {
                      final isSelected = value.name == selectedDay.name;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8, right: 8.0),
                        child: Chip(
                          label: Text(value.name),
                          backgroundColor: LeonidasTheme.whiteTint[0],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? LeonidasTheme.green
                                  : LeonidasTheme.whiteTint[1],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            ...selectedDay.exercises.map((exercise) {
              return ExerciseSetsTable(
                stage: selectedStage,
                exercise: exercise,
                routine: selectedRoutine,
                weightSetup: store.currentWeightSetup,
              );
            }),
          ],
        ),
      ),
    );
  }
}
