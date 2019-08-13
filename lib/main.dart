import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leonidas/icons/bottom_nav_icons.dart';
import 'package:leonidas/utils/sentry.dart';

// ignore: prefer_void_to_null
Future<Null> main() async {
  await DotEnv().load('.env');
  // Setup sentry
  final Sentry sentry = Sentry();

  // Report to sentry when error is detected
  // ignore: prefer_void_to_null
  runZoned<Future<Null>>(() async {
    runApp(MyApp());
  }, onError: (dynamic error, dynamic stackTrace) async {
    await sentry.reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.dark, accentColor: Colors.red),
      home: MyHomePage(title: 'Fsslutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _pageIndex = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        items: [
          BottomNavigationBarItem(
              title: Text('Tracker'), icon: Icon(BottomNav.diary)),
          BottomNavigationBarItem(
            title: Text('Workouts'),
            icon: Icon(BottomNav.dumbbell),
          ),
          BottomNavigationBarItem(
            title: Text('History'),
            icon: Icon(BottomNav.history),
          )
        ],
        onTap: (newIndex) {
          _setPage(newIndex);
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
