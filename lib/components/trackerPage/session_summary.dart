import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leonidas/leonidas_theme.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:leonidas/models/countdown_timer.dart';
import 'package:provider/provider.dart';

class SessionSummary extends StatelessWidget {
  const SessionSummary({Key key, this.store}) : super(key: key);
  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final Duration totalTime =
        store.exerciseStopTime.difference(store.exerciseStartTime);
    final session =
        store.routines[store.selectedRoutineIdx].sessions[store.currentSessionIdx];
    final cycle = store.routines[store.selectedRoutineIdx].progression
        .cycles[store.currentCycleIdx];

    return Scaffold(
      backgroundColor: LeonidasTheme.whiteTint[0],
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  DateFormat('EEEE, MMM d').format(store.exerciseStartTime),
                  style: LeonidasTheme.h3,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Chip(
                  backgroundColor: LeonidasTheme.primaryColor,
                  label: Text(cycle.name),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Chip(
                    backgroundColor: LeonidasTheme.secondaryColor,
                    label: Text(session.name),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 32),
                  child: Text(
                    'TOTAL TIME',
                    style: LeonidasTheme.overline.apply(color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Consumer<CountdownTimer>(
                  builder: (context, timer, child) {
                    return Text(
                      formatDuration(totalTime),
                      style: LeonidasTheme.h3.apply(color: Colors.white),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          store.currentSessionIdx++;
          store.currentActivity = 0;
          store.isLoggingResult = false;
          Navigator.of(context).pop();
        },
        label: Text('LOG RESULT'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: LeonidasTheme.whiteTint[1],
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () {
                showDialog<AlertDialog>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text('Discard current workout session result?'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text('Yes'),
                          onPressed: () {
                            store.isLoggingResult = false;
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes - 60 * hours;
    final seconds = duration.inSeconds - 60 * minutes;
    String finalString = '';
    if (hours > 0) {
      finalString += hours.toString() + 'h ';
    }
    if (minutes > 0) {
      finalString += minutes.toString() + 'm ';
    }
    if (seconds > 0) {
      finalString += seconds.toString() + 's';
    }
    return finalString;
  }
}
