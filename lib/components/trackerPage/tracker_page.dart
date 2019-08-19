import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonidas/components/trackerPage/exercise_item.dart';
import 'package:leonidas/leonidas_theme.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:leonidas/models/countdown_timer.dart';
import 'package:provider/provider.dart';

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

    final nextActivities = activities.sublist(store.currentActivity);
    final nextExerciseName = findNextExercise(activities, store.currentActivity)
        .exercise
        .name;

    return Scaffold(
      backgroundColor: LeonidasTheme.whiteTint[0],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<CountdownTimer>(
        builder: (context, value, child) {
          value.countdownCallback = () {
            value.countUp();
            if (store.currentActivity == 0) {
              return;
            }
            if (nextActivities[0] is HeaderItem) {
              store.currentActivity = store.currentActivity + 2;
            } else {
              store.currentActivity++;
            }
          };
          return FloatingActionButton.extended(
            onPressed: () {
              if (nextActivities[0] is HeaderItem) {
                store.currentActivity = store.currentActivity + 2;
              } else {
                store.currentActivity++;
              }
              value.stop();
              final nextActivity = nextActivities[1];
              if (store.currentActivity != 0 && nextActivity is RestItem) {
                value.countdownFrom(nextActivity.duration);
              } else {
                value.countUp();
              }
            },
            label: Text('FINISH'),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Only the tree below needs to be updated
            // when countdown changes.
            Consumer<CountdownTimer>(
              builder: (context, value, child) {
                return Center(
                  child: Text(
                    value.toString(),
                    style: LeonidasTheme.h1.apply(color: Colors.white),
                  ),
                );
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  nextExerciseName ?? '',
                  style: LeonidasTheme.h4Heavy,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: ListView.builder(
                  itemCount: nextActivities.length,
                  itemBuilder: (context, index) {
                    final activity = nextActivities[index];
                    if (activity is ExerciseItem) {
                      return Card(
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
                        color: LeonidasTheme.whiteTint[1],
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

  ExerciseItem findNextExercise(List<ActivityListItem> activities,
      int currentActivityIdx,) {
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
        final begin = Offset(0.0, 1.0);
        final end = Offset.zero;
        final curve = Curves.ease;
        final tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
