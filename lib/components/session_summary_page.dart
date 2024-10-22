import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leonidas/leonidas_theme.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:leonidas/models/countdown_timer.dart';
import 'package:provider/provider.dart';

class SessionSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final totalTime =
        store.exerciseStopTime.difference(store.exerciseStartTime);
    final session = store.currentSession;
    final stage = store.currentStage;

    return Scaffold(
      backgroundColor: LeonidasTheme.whiteTint[0],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      DateFormat('EEEE\nd MMM y')
                          .format(store.exerciseStartTime),
                      style: LeonidasTheme.h2,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Chip(
                    backgroundColor: LeonidasTheme.blue,
                    label: Text(stage.name),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Chip(
                      backgroundColor: LeonidasTheme.green,
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
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
        },
        label: Text('CLOSE'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: LeonidasTheme.whiteTint[1],
        child: Container(
          height: 56,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  showDialog<AlertDialog>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content:
                            Text('Discard current workout session result?'),
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

  static Route createRoute() {
    return PageRouteBuilder<SessionSummaryPage>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SessionSummaryPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        final curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final opacityAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: opacityAnimation,
          child: child,
        );
      },
    );
  }
}
