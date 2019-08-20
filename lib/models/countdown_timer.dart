import 'dart:async';

import 'package:flutter/cupertino.dart';

enum CountingDirection { up, down }

class CountdownTimer extends ChangeNotifier {
  int _timeLeft = 0;
  bool _isCounting = false;

  bool get isCounting => _isCounting;

  set isCounting(bool isCounting) {
    _isCounting = isCounting;
    notifyListeners();
  }
  Timer _timer;
  CountingDirection countingDirection = CountingDirection.down;
  Function countdownCallback;

  set timer(Timer newTimer) {
    if(_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _timer = newTimer;
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
    isCounting = true;
    timeLeft = lengthInSecond;
    countingDirection = CountingDirection.down;
    if (callback != null) {
      countdownCallback = callback;
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeft--;
      if (timeLeft == 0) {
        if (countdownCallback != null) {
          countdownCallback();
        }
        isCounting = false;
        timer.cancel();
      }
    });
  }

  void countUp() {
    isCounting = true;
    timeLeft = 0;
    countingDirection = CountingDirection.up;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      timeLeft++;
    });
  }

  int stop() {
    final timeOnCancelled = timeLeft;
    timer.cancel();
    timer = null;
    timeLeft = 0;
    isCounting = false;
    return timeOnCancelled;
  }

  void pause() {
    timer.cancel();
    timer = null;
    isCounting = false;
  }

  void continueCounting() {
    if (countingDirection == CountingDirection.down) {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        timeLeft--;
        if (timeLeft == 0) {
          timer.cancel();
          isCounting = false;
          countdownCallback();
        }
      });
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        timeLeft++;
      });
    }
    isCounting = true;
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
