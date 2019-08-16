import 'dart:async';

import 'package:flutter/cupertino.dart';

class CountdownTimer extends ChangeNotifier {
  int _timeLeft = 0;
  bool isCounting = false;

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

  void countdownFrom(int lengthInSecond) {
    isCounting = true;
    timeLeft = lengthInSecond;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        timer.cancel();
        isCounting = false;
      }
    });
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
