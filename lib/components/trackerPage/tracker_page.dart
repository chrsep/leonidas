import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonidas/components/trackerPage/exercise_item.dart';
import 'package:leonidas/leonidas_theme.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:leonidas/models/countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class TrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get app wide state and timer from provider
    final store = Provider.of<AppStore>(context);
    final routine = store.routines[store.selectedRoutineIdx];

    final List<ActivityListItem> activities = [];
    final exerciseList = store.currentSessionExercises;
    // Create list of activities to be done
    for (int i = 0; i < exerciseList.length; i++) {
      final exercise = exerciseList[i];
      if (i > 1) {
        final ExerciseItem lastExerciseItem =
            activities.lastWhere((activity) => activity is ExerciseItem);
        if (lastExerciseItem.exercise.name != exercise.item1.name) {
          activities.add(HeaderItem(exercise.item1.name));
        }
      }
      activities.add(ExerciseItem(exercise.item1, exercise.item2, routine));
      activities.add(RestItem(exercise.item2.rest));
    }

    final activitiesLeft = activities.sublist(store.currentActivity);
    final nextExerciseName =
        findNextExercise(activities, store.currentActivity).exercise.name;

    Color colorIdentifier;
    String infoText;
    String buttonText;
    if (!store.exerciseStarted) {
      infoText = 'STARTS IN...';
      buttonText = 'START NOW';
    } else if (activitiesLeft[0] is ExerciseItem) {
      colorIdentifier = LeonidasTheme.accentColor;
      buttonText = 'DID IT';
      infoText = 'GO';
    } else if (activitiesLeft[0] is RestItem) {
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
        builder: (context, value, child) {
          value.countdownCallback = () {
            value.countUp();
            Vibration.hasVibrator().then<void>((dynamic value) {
              if (value) {
                return Vibration.vibrate();
              } else {
                return null;
              }
            });
            if (store.currentActivity == 0) {
              store.exerciseStarted = true;
              return;
            }
            if (activitiesLeft[0] is HeaderItem) {
              store.currentActivity = store.currentActivity + 2;
            } else {
              store.currentActivity++;
            }
          };
          return FloatingActionButton.extended(
            backgroundColor: colorIdentifier,
            onPressed: () {
              if (!store.exerciseStarted) {
                store.exerciseStarted = true;
                value.countUp();
                return;
              }
              if (activitiesLeft[0] is HeaderItem) {
                store.currentActivity = store.currentActivity + 2;
              } else {
                store.currentActivity++;
              }
              value.stop();
              final nextActivity = activitiesLeft[1];
              if (store.currentActivity != 0 && nextActivity is RestItem) {
                value.countdownFrom(nextActivity.duration);
              } else {
                value.countUp();
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
                        return AlertDialog(
                          title: Text('Do you want to restart?'),
                          content: Text(
                              'You can restart session to start from the very beginning '
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
                                final currentActivity =
                                    (activitiesLeft[0] is HeaderItem)
                                        ? activitiesLeft[1]
                                        : activitiesLeft[0];
                                if (!store.exerciseStarted) {
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
                                store.exerciseStarted = false;
                                store.currentActivity = 0;
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
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
                                store.exerciseStarted = false;
                                store.currentActivity = 0;

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
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
                  nextExerciseName.toUpperCase() ?? '',
                  style: LeonidasTheme.h4Heavy.apply(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ListView.builder(
                  itemCount: activitiesLeft.length,
                  itemBuilder: (context, index) {
                    final activity = activitiesLeft[index];
                    final cardColor = store.exerciseStarted && index == 0 ||
                            // In case first item is actually a header
                            activitiesLeft[0] is HeaderItem && index == 1
                        ? colorIdentifier
                        : null;

                    if (activity is ExerciseItem) {
                      return Card(
                        color: cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                activity.calculatedWeight.toString() + ' Kg',
                                style: LeonidasTheme.h5,
                              ),
                              Flex(
                                direction: Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(activity.set.sets.toString() + ' Sets'),
                                  Text(activity.set.reps.toString() + ' Reps'),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    } else if (activity is RestItem) {
                      return Card(
                        color: cardColor ?? LeonidasTheme.whiteTint[1],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Rest'),
                              Text(activity.duration.toString() + 's')
                            ],
                          ),
                        ),
                      );
                    } else if (activity is HeaderItem) {
                      return index > 0
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  activity.value,
                                  style: LeonidasTheme.h4,
                                ),
                              ),
                            )
                          : Container();
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

  ExerciseItem findNextExercise(
    List<ActivityListItem> activities,
    int currentActivityIdx,
  ) {
    return activities.isEmpty
        ? null
        : activities
            .sublist(currentActivityIdx - 1 > 0 ? currentActivityIdx - 1 : 0)
            .firstWhere((activity) => activity is ExerciseItem);
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
