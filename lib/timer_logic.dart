import 'dart:async';
import 'package:flutter/material.dart';

typedef UpdateCallback = void Function();

class StopWatchTimer {
  bool isActive = false;
  final Stopwatch _stopWatch = Stopwatch();
  final int targetDuration;
  final UpdateCallback onUpdate;
  final ValueNotifier<int> elapsedTimeNotifier = ValueNotifier(0);

  StopWatchTimer({required this.targetDuration, required this.onUpdate});

  int get elapsedTime {
    return _stopWatch.elapsedMilliseconds;
  }

  String get remainingTime {
    final int remainingMilliseconds =
        targetDuration - _stopWatch.elapsedMilliseconds;
    final Duration remainingDuration =
        Duration(milliseconds: remainingMilliseconds);
    final String hours = remainingDuration.inHours.toString().padLeft(2, '0');
    final String minutes =
        (remainingDuration.inMinutes % 60).toString().padLeft(2, '0');
    final String seconds =
        (remainingDuration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void start() {
    if (!isActive) {
      _stopWatch.start();
      isActive = true;
      Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (_stopWatch.isRunning) {
          elapsedTimeNotifier.value = _stopWatch.elapsedMilliseconds;
          onUpdate();
        }
      });
      onUpdate();
    }
  }

  void stop() {
    if (isActive) {
      _stopWatch.stop();
      isActive = false;
      onUpdate();
    }
  }

  void reset() {
    _stopWatch.reset();
    isActive = false;
    elapsedTimeNotifier.value = 0;
    onUpdate();
  }
}
