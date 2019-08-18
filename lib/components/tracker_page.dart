import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leonidas/leonidas_theme.dart';
import 'package:leonidas/models/countdown_timer.dart';
import 'package:provider/provider.dart';

class TrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timer = Provider.of<CountdownTimer>(context);
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
