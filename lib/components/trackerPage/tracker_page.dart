import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:leonidas/components/session_summary_page.dart';
import 'package:leonidas/components/trackerPage/exercise_item.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:leonidas/models/countdown_timer.dart';
import 'package:provider/provider.dart';

import '../../leonidas_theme.dart';

class TrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get app wide state and timer from provider
    final store = Provider.of<AppStore>(context);
    final List<ActivityListItem> activities = store.currentSessionActivities;
    List<ActivityListItem> nextActivities;
    // if current topmost list item is a HeaderItem, we need to increment the currentActivityIdx
    // by 2 to skip over the header item and display the next activity.
    int nextActivityIndexDistance = 1;
    if (store.currentActivityIdx < activities.length &&
        activities[store.currentActivityIdx] is HeaderItem) {
      // Do not display header item on the list on first index.
      nextActivities = activities.sublist(store.currentActivityIdx + 1);
      nextActivityIndexDistance = 2;
    } else {
      nextActivities = activities.sublist(store.currentActivityIdx);
    }

    Color colorIdentifier;
    String infoText;
    String buttonText;
    if (nextActivities.isEmpty) {
      infoText = 'FINISH';
      buttonText = 'SEE SUMMARY';
      colorIdentifier = Colors.green;
    } else if (!store.isExercising) {
      infoText = 'STARTS IN...';
      buttonText = 'START NOW';
    } else if (nextActivities[0] is ExerciseItem) {
      colorIdentifier = LeonidasTheme.accentColor;
      buttonText = 'DID IT';
      infoText = 'GO';
    } else if (nextActivities[0] is RestItem) {
      colorIdentifier = LeonidasTheme.blue;
      infoText = 'REST';
      buttonText = 'SKIP REST';
    } else {
      colorIdentifier = LeonidasTheme.accentColor;
      infoText = 'GO';
      buttonText = 'DID IT';
    }

    var exerciseName = '';
    if (nextActivities.isNotEmpty) {
      exerciseName = nextActivities[0].name.toUpperCase();
    } else {
      exerciseName = 'ALL DONE';
    }

    return Scaffold(
      backgroundColor: LeonidasTheme.whiteTint[0],
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Consumer<CountdownTimer>(
        builder: (context, timer, child) {
          timer.countdownCallback = () {
            _continueToNextActivity(context, store, timer, nextActivities,
                nextActivityIndexDistance);
          };
          return FloatingActionButton.extended(
            backgroundColor: colorIdentifier,
            onPressed: () {
              _continueToNextActivity(context, store, timer, nextActivities,
                  nextActivityIndexDistance);
            },
            label: Text(buttonText),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: LeonidasTheme.whiteTint[4],
        child: Container(
          height: 57,
          child: Consumer<CountdownTimer>(builder: (context, timer, _) {
            return Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                IconButton(
                  icon: Icon(timer.isActive ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (timer.isActive) {
                      timer.pause();
                    } else {
                      timer.continueCounting();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings_backup_restore),
                  onPressed: () {
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (context) {
                        return _buildResetDialog(
                            context, timer, store, nextActivities);
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (context) {
                        return _buildCancelDialog(context, store, timer);
                      },
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Only the tree below needs to be updated
            // when countdown changes.
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                infoText,
                style: LeonidasTheme.subtitle1.apply(color: colorIdentifier),
              ),
            ),
            Consumer<CountdownTimer>(
              builder: (context, timer, child) {
                return Center(
                  child: AnimatedDefaultTextStyle(
                    child: Text(timer.toString()),
                    curve: Curves.bounceInOut,
                    style: LeonidasTheme.h1.apply(
                        color: timer.isActive ? Colors.white : Colors.white30),
                    duration: Duration(milliseconds: 256),
                  ),
                );
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  exerciseName,
                  style: LeonidasTheme.h4Heavy.apply(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: nextActivities.length,
                itemBuilder: (context, index) {
                  final activity = nextActivities[index];
                  final cardColor =
                      store.isExercising && index == 0 ? colorIdentifier : null;

                  if (activity is ExerciseItem) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: activity.buildWidget(cardColor,
                          showWeights: index == 0),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: activity.buildWidget(cardColor),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResetDialog(BuildContext context, CountdownTimer timer,
      AppStore store, List<ActivityListItem> activityTodos) {
    return AlertDialog(
      title: Text('Do you want to restart?'),
      content: Text('You can restart session to start from the very beginning '
          'or only restart timer to start your current '
          'activity from the  beginning.'),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Restart timer'),
          onPressed: () {
            final currentActivity = activityTodos[0];
            if (!store.isExercising) {
              timer.timeLeft = 10;
            } else if (currentActivity is ExerciseItem) {
              timer.timeLeft = 0;
            } else if (currentActivity is RestItem) {
              timer.timeLeft = currentActivity.duration;
            } else {
              timer.timeLeft = 10;
            }
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Restart session'),
          onPressed: () {
            timer.countdownFrom(10);
            store.isExercising = false;
            store.currentActivityIdx = 0;
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  void _continueToNextActivity(
    BuildContext context,
    AppStore store,
    CountdownTimer timer,
    List<ActivityListItem> nextActivities,
    int nextActivityIndexDistance,
  ) {
    if (nextActivities.isEmpty) {
      store.exerciseStopTime = DateTime.now();
      store.moveToNextSession();
      _resetTrackerStats(timer, store);

      Navigator.of(context)
          .pushReplacement<SessionSummaryPage, SessionSummaryPage>(
              SessionSummaryPage.createRoute());

      return;
    }
    // If exercise is not started (we're still on the starting countdown),
    // start it
    if (!store.isExercising) {
      store.isExercising = true;
      timer.countUp();
      return;
    }

    // Increment current activity twice to skip the header
    // when topmost item is a header
    store.currentActivityIdx += nextActivityIndexDistance;

    // if there is no other activities after current one, just stop.
    if (nextActivities.length < 2) {
      timer.stop();
      return;
    }

    // Count up when next item is an exercise, countdown if its rest.
    final nextActivity = nextActivities[1];
    if (nextActivity is RestItem) {
      timer.countdownFrom(nextActivity.duration);
    } else {
      timer.countUp();
    }
  }

  void _resetTrackerStats(CountdownTimer timer, AppStore store) {
    timer.stop();
    store.isExercising = false;
    final localNotif = FlutterLocalNotificationsPlugin();
    localNotif.cancelAll();
  }

  Widget _buildCancelDialog(
      BuildContext context, AppStore store, CountdownTimer timer) {
    return AlertDialog(
      content: Text('Cancel workout session?'),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            _resetTrackerStats(timer, store);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  static Route createRoute() {
    return PageRouteBuilder<TrackerPage>(
      pageBuilder: (context, animation, secondaryAnimation) => TrackerPage(),
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
