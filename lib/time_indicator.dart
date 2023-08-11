import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ctimer_prototype_1/timer_logic.dart';
import 'time_idcontrol.dart';

class TimerIndicator extends StatelessWidget {
  final List<StopWatchTimer> timers;

  const TimerIndicator(this.timers, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (timers.length > 1)
          CarouselSlider(
            carouselController: timerIndictorController,
            items: timers.map((timer) {
              final String elapsedTime = timer.remainingTime;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  elapsedTime,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
                height: 29,
                scrollDirection: Axis.horizontal,
                viewportFraction: 0.3,
                enableInfiniteScroll: false),
          ),
      ],
    );
  }
}
