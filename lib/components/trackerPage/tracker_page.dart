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
    final List<ActivityListItem> activities = store.currentSessionActivities;
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
      return SessionProgress(activitiesLeft);
    }
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
