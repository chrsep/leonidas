import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:leonidas/notification_helper.dart';
import 'package:vibration/vibration.dart';

enum CountingDirection { up, down }

class CountdownTimer extends ChangeNotifier {
  final notif = NotificationHelper();
  int _timeLeft = 0;

  bool get isActive => timer != null;
  bool _isCounting = false;

  bool get isCounting => _isCounting;

  set isCounting(bool isCounting) {
    _isCounting = isCounting;
    notifyListeners();
  }

  Timer _timer;
  CountingDirection countingDirection = CountingDirection.down;
  Function countdownCallback;

  Timer get timer => _timer;

  Timer cancelNotifTimer;

  set timer(Timer newTimer) {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _timer = newTimer;
    isCounting = true;
    notifyListeners();
  }

  int get timeLeft => _timeLeft;

  set timeLeft(int value) {
    _timeLeft = value;
    if (cancelNotifTimer != null) {
      cancelNotifTimer.cancel();
      cancelNotifTimer = null;
    }
    notif.send(NotificationHelper.TRACKER, 0, 'Tracking workout',
        secondIntFormat(value));
    notifyListeners();
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
        _countdownFinished(timer);
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
    isCounting = false;
    _cancelNotification();
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
          _countdownFinished(timer);
        }
      });
    } else {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        timeLeft++;
      });
    }
  }

  void _countdownFinished(Timer timer) {
    timer.cancel();
    if (countdownCallback != null) {
      countdownCallback();
    }
    Vibration.hasVibrator().then<void>((dynamic value) {
      if (value) {
        return Vibration.vibrate();
      } else {
        return null;
      }
    });
    _cancelNotification();
  }

  void _cancelNotification() {
    cancelNotifTimer = Timer(Duration(seconds: 1), () {
      notif.cancel(0);
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
