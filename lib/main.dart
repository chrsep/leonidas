import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leonidas/icons/bottom_nav_icons.dart';
import 'package:leonidas/utils/sentry.dart';

/// Used on Bottom Navigation for designating top level sections.
class Section {
  const Section(this.index, this.title, this.icon, this.page);

  final int index;
  final String title;
  final IconData icon;
  final Widget page;
}

List<Section> sections = [
  Section(0, 'Tracker', BottomNav.diary, Text('test')),
  Section(1, 'Workouts', BottomNav.dumbbell, Text('tests')),
  Section(2, 'History', BottomNav.history, Text('testdsa')),
];

// main() is the entry point of dart programs, similar to C, use this function
// to instantiate anything on
// ignore: prefer_void_to_null
Future<Null> main() async {
  await DotEnv().load('.env');
  // Setup sentry
  final Sentry sentry = Sentry();

  // Report to sentry when error is detected
  // ignore: prefer_void_to_null
  runZoned<Future<Null>>(() async {
    runApp(Leonidas());
  }, onError: (dynamic error, dynamic stackTrace) async {
    await sentry.reportError(error, stackTrace);
  });
}

// Our application root widget, call this on test to render the whole App
class Leonidas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leonidas',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.redAccent,
      ),
      home: HomePage(),
    );
  }
}

// This is the first widget our application renders
class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<Key> _sectionKeys =
      List.generate(sections.length, (_) => GlobalKey());

  final List<BottomNavigationBarItem> _bottomNavItems = sections
      .map((Section section) => BottomNavigationBarItem(
          icon: Icon(section.icon), title: Text(section.title)))
      .toList();

  int _currPageIndex = 0;
  List<FadeTransition> _sectionWidgets;
  List<AnimationController> _faders;

  @override
  void initState() {
    super.initState();

    _faders = sections
        .map<AnimationController>((Section section) => AnimationController(
            vsync: this, duration: Duration(milliseconds: 200)))
        .toList();
    _sectionWidgets = sections
        .map((Section section) => FadeTransition(
              opacity: _faders[section.index].drive(
                CurveTween(curve: Curves.fastOutSlowIn),
              ),
              child: KeyedSubtree(
                key: _sectionKeys[section.index],
                child: section.page,
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currPageIndex,
        items: _bottomNavItems,
        onTap: (newIndex) {
          setState(() {
            _currPageIndex = newIndex;
          });
        },
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: sections.map((Section section) {
            if (section.index == _currPageIndex) {
              _faders[section.index].forward();
              return _sectionWidgets[section.index];
            } else {
              _faders[section.index].reverse();
              return _faders[section.index].isAnimating
                  ? IgnorePointer(child: _sectionWidgets[section.index])
                  : Offstage(child: _sectionWidgets[section.index]);
            }
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) {
      controller.dispose();
    }
    super.dispose();
  }
}
