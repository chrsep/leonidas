import 'dart:async';

import 'package:flutter/cupertino.dart';

enum CountingDirection { up, down }

class CountdownTimer extends ChangeNotifier {
  int _timeLeft = 0;
  bool get isCounting {
    return timer != null;
  }
  Timer _timer;
  CountingDirection countingDirection = CountingDirection.down;
  Function countdownCallback;

  set timer(Timer newTimer) {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _timer = newTimer;
    notifyListeners();
  }

  Timer get timer {
    return _timer;
  }

  set timeLeft(int value) {
    _timeLeft = value;
    notifyListeners();
  }

  int get timeLeft {
    return _timeLeft;
  }

  @override
  String toString() {
    return secondIntFormat(timeLeft);
  }

  void countdownFrom(int lengthInSecond, {Function callback}) {
    timeLeft = lengthInSecond;
    countingDirection = CountingDirection.down;
    if (callback != null) {
      countdownCallback = callback;
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeft--;
      if (timeLeft == 0) {
        timer.cancel();
        if (countdownCallback != null) {
          countdownCallback();
        }
      }
    });
  }

  void countUp() {
    timeLeft = 0;
    countingDirection = CountingDirection.up;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeft++;
    });
  }

  int stop() {
    final timeOnCancelled = timeLeft;
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    timeLeft = 0;
    return timeOnCancelled;
  }

  void pause() {
    timer.cancel();
    timer = null;
  }

  void continueCounting() {
    if (countingDirection == CountingDirection.down) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        timeLeft--;
        if (timeLeft == 0) {
          timer.cancel();
          countdownCallback();
        }
      });
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        timeLeft++;
      });
    }
  }
}

String secondIntFormat(int inputSecond) {
  final minutes = (inputSecond / 60).floor();
  final seconds = inputSecond - 60 * minutes;
  final minutesString =
  minutes > 9 ? minutes.toString() : '0' + minutes.toString();
  final secondString =
  seconds > 9 ? seconds.toString() : '0' + seconds.toString();
  return minutesString + ':' + secondString;
}
