// This is the first widget our application renders
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:leonidas/components/diary_section.dart';
import 'package:leonidas/components/coming_soon_placeholder.dart';
import 'package:leonidas/components/trackerPage/tracker_page.dart';
import 'package:leonidas/icons/bottom_nav_icons.dart';
import 'package:leonidas/leonidas_theme.dart';
import 'package:leonidas/models/app_store.dart';
import 'package:leonidas/models/countdown_timer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// Handle top level navigation between sections
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<Key> _sectionKeys =
  List.generate(sections.length, (_) => GlobalKey());

  final List<BottomNavigationBarItem> _bottomNavItems = sections
      .map((Section section) =>
      BottomNavigationBarItem(
        icon: Icon(section.icon),
        title: Text(section.title),
      ))
      .toList();

  int _currPageIndex = 0;
  List<FadeTransition> _sectionWidgets;
  List<AnimationController> _faders;
  double height;

  @override
  void initState() {
    super.initState();

    height = 100;
    _faders = sections
        .map<AnimationController>((Section section) =>
        AnimationController(
            vsync: this, duration: Duration(milliseconds: 200)))
        .toList();
    _sectionWidgets = sections
        .map((Section section) =>
        FadeTransition(
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
      extendBody: true,
      floatingActionButton: Consumer<AppStore>(
        builder: (context, store, child) {
          return Consumer<CountdownTimer>(
            builder: (context, timer, child) {
              String fabText;
              if (timer.isCounting && timer.timeLeft < 9) {
                fabText = timer.toString();
              } else if (store.isLoggingResult) {
                fabText = 'LOG';
              } else {
                fabText = 'START';
              }
              return FloatingActionButton.extended(
                // to prevent label from changing right away during transition
                // we need to wait until time left is under 9
                label: Text(fabText),
                onPressed: () {
                  if (!timer.isCounting) {
                    timer.countdownFrom(10);
                    store.exerciseStartTime = DateTime.now();
                    store.currentActivity = 0;
                  }
                  Navigator.of(context)
                      .push<TrackerPage>(TrackerPage.createRoute());
                },
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Color(0xFF121212),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.hardEdge,
        child: BottomNavigationBar(
          backgroundColor: LeonidasTheme.whiteTint[4],
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          currentIndex: _currPageIndex,
          items: _bottomNavItems,
          onTap: (newIndex) {
            if (newIndex != 2) {
              setState(() {
                _currPageIndex = newIndex;
              });
            }
          },
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
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

/// Used on Bottom Navigation for designating top level sections.
class Section {
  const Section(this.index, this.title, this.icon, this.page);

  final int index;
  final String title;
  final IconData icon;
  final Widget page;
}

List<Section> sections = [
  Section(0, 'Diary', BottomNav.diary, DiarySection()),
  Section(
      1,
      'Plans',
      BottomNav.dumbbell,
      ComingSoonPlaceholder(
        sectionName: 'Planning',
      )),
  Section(2, '', null, Text('testdsa')),
  Section(3, 'History', BottomNav.history,
      ComingSoonPlaceholder(sectionName: 'History')),
  Section(
      4,
      'Menu',
      Icons.menu,
      ComingSoonPlaceholder(
        sectionName: 'Menu',
      )),
];
