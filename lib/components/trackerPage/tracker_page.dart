import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonidas/components/trackerPage/exercise_item.dart';
import 'package:leonidas/components/trackerPage/session_progress.dart';
import 'package:leonidas/components/trackerPage/session_summary.dart';
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

    final activitiesLeft = activities.sublist(store.currentActivity);
    if (activitiesLeft.isEmpty) {
      if (store.isExercising) {
        store.isExercising = false;
      }
      store.isLoggingResult = true;
      return Consumer<CountdownTimer>(builder: (context, timer, _) {
        timer.stop();
        return SessionSummary(store: store);
      });
    } else {
      final currentExerciseName =
          findCurrentExerciseName(activities, store.currentActivity)
              .exercise
              .name;
      return SessionProgress(activitiesLeft, currentExerciseName);
    }
  }

  ExerciseItem findCurrentExerciseName(
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
