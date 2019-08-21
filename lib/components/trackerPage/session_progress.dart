import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:leonidas/models/countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../leonidas_theme.dart';
import 'exercise_item.dart';

class SessionProgress extends StatelessWidget {
  const SessionProgress(this.activityTodos, this.currentExerciseName);

  final List<ActivityListItem> activityTodos;
  final String currentExerciseName;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);

    Color colorIdentifier;
    String infoText;
    String buttonText;
    if (!store.isExercising) {
      infoText = 'STARTS IN...';
      buttonText = 'START NOW';
    } else if (activityTodos[0] is ExerciseItem) {
      colorIdentifier = LeonidasTheme.accentColor;
      buttonText = 'DID IT';
      infoText = 'GO';
    } else if (activityTodos[0] is RestItem) {
      colorIdentifier = LeonidasTheme.primaryColor;
      infoText = 'REST';
      buttonText = 'SKIP REST';
    } else {
      colorIdentifier = LeonidasTheme.accentColor;
      infoText = 'GO';
      buttonText = 'DID IT';
    }

    return Scaffold(
      backgroundColor: LeonidasTheme.whiteTint[0],
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Consumer<CountdownTimer>(
        builder: (context, timer, child) {
          timer.countdownCallback = () {
            timer.countUp();
            Vibration.hasVibrator().then<void>((dynamic value) {
              if (value) {
                return Vibration.vibrate();
              } else {
                return null;
              }
            });
            if (store.currentActivity == 0) {
              store.isExercising = true;
              return;
            }
            if (activityTodos[0] is HeaderItem) {
              store.currentActivity = store.currentActivity + 2;
            } else {
              store.currentActivity++;
            }
          };
          return FloatingActionButton.extended(
            backgroundColor: colorIdentifier,
            onPressed: () {
              // If exercise is not started (we're still on the starting countdown),
              // start it
              if (!store.isExercising) {
                store.isExercising = true;
                timer.countUp();
                return;
              }

              // Increment current activity twice to skip the header
              // when topmost item is a header
              if (activityTodos[0] is HeaderItem) {
                store.currentActivity = store.currentActivity + 2;
              } else {
                store.currentActivity++;
              }

              // if there is no other activities, just stop.
              if (activityTodos.length < 2) {
                timer.stop();
                return;
              }

              // Count up when next item is an exercise, countdown if its rest.
              final nextActivity = activityTodos[1];
              if (nextActivity is RestItem) {
                timer.countdownFrom(nextActivity.duration);
              } else {
                timer.countUp();
              }
            },
            label: Text(buttonText),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: LeonidasTheme.whiteTint[4],
        child: Container(
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
                  icon: Icon(timer.isCounting ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    if (timer.isCounting) {
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
                        return _buildResetDialog(context, timer, store);
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
                    child: Text(
                      timer.toString(),
                    ),
                    curve: Curves.bounceInOut,
                    style: timer.isCounting
                        ? LeonidasTheme.h1.apply(color: Colors.white)
                        : LeonidasTheme.h1.apply(color: Colors.white30),
                    duration: Duration(milliseconds: 256),
                  ),
                );
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  currentExerciseName.toUpperCase() ?? '',
                  style: LeonidasTheme.h4Heavy.apply(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ListView.builder(
                  itemCount: activityTodos.length,
                  itemBuilder: (context, index) {
                    final activity = activityTodos[index];
                    final cardColor = store.isExercising && index == 0 ||
                            // In case first item is actually a header
                            activityTodos[0] is HeaderItem && index == 1
                        ? colorIdentifier
                        : null;

                    if (activity is ExerciseItem) {
                      return activity.buildWidget(cardColor);
                    } else if (activity is RestItem) {
                      return activity.buildWidget(cardColor);
                    } else if (activity is HeaderItem) {
                      return index > 0 ? activity.buildWidget() : Container();
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResetDialog(
      BuildContext context, CountdownTimer timer, AppStore store) {
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
            final currentActivity = (activityTodos[0] is HeaderItem)
                ? activityTodos[1]
                : activityTodos[0];
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
            store.currentActivity = 0;
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
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
          timer.stop();
          store.isExercising = false;
          store.currentActivity = 0;

          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      )
    ],
  );
}
