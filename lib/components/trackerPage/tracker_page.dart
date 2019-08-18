import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonidas/leonidas_theme.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:leonidas/models/countdown_timer.dart';
import 'package:leonidas/utils/weights.dart';
import 'package:provider/provider.dart';

class TrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<CountdownTimer>(context);
    final store = Provider.of<AppStore>(context);
    final routine = store.routines[store.selectedRoutineIdx];
    final exerciseList = store.currentSessionExercises;

    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                timer.toString(),
                style: LeonidasTheme.h1.apply(color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: exerciseList.length,

                itemBuilder: (context, index) {
                  final completeExercise = exerciseList[index];
                  final calculatedWeight = calculateWeight(
                      completeExercise.item1, routine, completeExercise.item2);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            completeExercise.item1.name,
                            style: LeonidasTheme.h5,
                          ),
                          Text(calculatedWeight.toString() + ' Kg'),
                          Text(completeExercise.item2.sets.toString() + ' Sets'),
                          Text(completeExercise.item2.reps.toString() + ' Reps'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
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
