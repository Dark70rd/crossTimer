import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ctimer_prototype_1/timer_logic.dart';
import 'package:ctimer_prototype_1/timer_widget.dart';
import 'package:ctimer_prototype_1/time_indicator.dart';
import 'time_idcontrol.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer starSoundtPlayer = AudioPlayer();
  final AudioPlayer endSoundPlayer = AudioPlayer();
  bool _automaticStartEnabled = false;
  bool _startSoundPlayed = false;

  int selectedHours = 0;
  int selectedMinutes = 0;
  int selectedSeconds = 0;

  ValueNotifier<int> hoursNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> minutesNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> secondsNotifier = ValueNotifier<int>(0);

  Map<int, String> timerNames = {};
  final List<StopWatchTimer> _timers = [];

  int selectedIndex = 0;

  final CarouselController _mainCarouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    starSoundtPlayer.setAsset('assets/sounds/start_beep.mp3');
    endSoundPlayer.setAsset('assets/sounds/end_beep.mp3');
    starSoundtPlayer.load();
    endSoundPlayer.load();
    // Add the default timer with a target duration of 5 minutes (300000 milliseconds)
    _initializeDefaultTimer();
  }

  void _initializeDefaultTimer() {
    setState(() {
      _timers
          .add(StopWatchTimer(targetDuration: 300000, onUpdate: _updateState));
    });
  }

  Future<void> _updateState() async {
    for (var timer in _timers) {
      if (timer.isActive) {
        if (!_startSoundPlayed) {
          starSoundtPlayer.setAsset('assets/sounds/start_beep.mp3');
          await starSoundtPlayer.play();
          _startSoundPlayed = true;
        }
        setState(() {});
        if (timer.elapsedTime >= timer.targetDuration) {
          endSoundPlayer.setAsset('assets/sounds/end_beep.mp3');
          await endSoundPlayer.play();
          timer.stop();
          timer.reset();
          _startSoundPlayed = false;
          if (_automaticStartEnabled) {
            final nextIndex = _timers.indexOf(timer) + 1;
            if (nextIndex < _timers.length) {
              _timers[nextIndex].start();
              starSoundtPlayer.setAsset('assets/sounds/start_beep.mp3');
              await starSoundtPlayer.play();
              _startSoundPlayed = true;
              _mainCarouselController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        }
        break;
      }
    }
  }

  void _addTimer(int customTimeDuration) {
    setState(() {
      _timers.add(StopWatchTimer(
          targetDuration: customTimeDuration, onUpdate: _updateState));
    });
  }

  void _removeTimer(int index) {
    setState(() {
      timerNames.remove(index);
      _timers.removeAt(index);
      if (selectedIndex >= _timers.length) {
        selectedIndex = _timers.length - 1;
      }
    });
  }

  void updateTimerName(int index, String name) {
    setState(() {
      timerNames[index] = name;
    });
  }

  Future<void> _showTimePicker(BuildContext context) async {
    await showModalBottomSheet(
        enableDrag: true,
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 250,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Time",
                  style: TextStyle(fontSize: 30.0, color: Colors.tealAccent),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: hoursNotifier,
                        builder: (context, hoursValue, child) {
                          return DropdownButton<int>(
                            underline: Container(),
                            padding: const EdgeInsets.only(bottom: 8),
                            value: hoursValue,
                            onChanged: (value) {
                              setState(() {
                                hoursNotifier.value = value!;
                              });
                            },
                            items: List.generate(24, (index) {
                              return DropdownMenuItem<int>(
                                alignment: Alignment.center,
                                value: index,
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: const TextStyle(
                                      fontSize: 38, color: Colors.tealAccent),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                      const Text(
                        "H",
                        style: TextStyle(
                          fontSize: 38,
                          color: Colors.tealAccent,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: minutesNotifier,
                        builder: (context, minutesValue, child) {
                          return DropdownButton<int>(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            underline: Container(),
                            value: minutesValue,
                            onChanged: (value) {
                              setState(() {
                                minutesNotifier.value = value!;
                              });
                            },
                            items: List.generate(60, (index) {
                              return DropdownMenuItem<int>(
                                alignment: Alignment.center,
                                value: index,
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: const TextStyle(
                                      fontSize: 38, color: Colors.tealAccent),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                      const Text(
                        "M",
                        style:
                            TextStyle(fontSize: 38, color: Colors.tealAccent),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: secondsNotifier,
                        builder: (context, secondsvalue, child) {
                          return DropdownButton<int>(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            underline: Container(),
                            value: secondsvalue,
                            onChanged: (value) {
                              setState(() {
                                secondsNotifier.value = value!;
                              });
                            },
                            items: List.generate(60, (index) {
                              return DropdownMenuItem<int>(
                                alignment: Alignment.center,
                                value: index,
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: const TextStyle(
                                      fontSize: 38, color: Colors.tealAccent),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                      const Text(
                        "S",
                        style:
                            TextStyle(fontSize: 38, color: Colors.tealAccent),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    int totalTimeMiliseconds = hoursNotifier.value * 3600000 +
                        minutesNotifier.value * 60000 +
                        secondsNotifier.value * 1000;
                    _addTimer(totalTimeMiliseconds);
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.check_sharp,
                    size: 40.0,
                    color: Colors.tealAccent,
                  ),
                ),
              ],
            ),
          );
        });
  }

  var appBarHeight = AppBar().preferredSize.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("XTIMER"),
        titleTextStyle:
            const TextStyle(fontSize: 26.0, color: Colors.tealAccent),
        actions: [
          PopupMenuButton(
            shadowColor: Colors.blueGrey,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            elevation: 6,
            icon: const Icon(
              Icons.settings_suggest_sharp,
              color: Colors.tealAccent,
            ),
            iconSize: 35,
            offset: Offset(0.0, appBarHeight),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: StatefulBuilder(builder: (context, setState) {
                    return Row(
                      children: [
                        const Icon(
                          Icons.timer_sharp,
                          color: Colors.tealAccent,
                          size: 30,
                        ),
                        const Spacer(),
                        const Text(
                          "TSync Mode",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.tealAccent,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                            value: _automaticStartEnabled,
                            onChanged: (value) {
                              setState(() {
                                _automaticStartEnabled = value;
                              });
                            }),
                      ],
                    );
                  }),
                ),
              ];
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 40, child: TimerIndicator(_timers)),
          CarouselSlider(
            carouselController: _mainCarouselController,
            items: _timers.asMap().entries.map((entry) {
              final timerIndex = entry.key;
              final timer = entry.value;
              return ValueListenableBuilder<int>(
                valueListenable: timer.elapsedTimeNotifier,
                builder: (context, value, child) {
                  return TimerWidget(timer,
                      onUpdate: _updateState,
                      timerIndex: timerIndex,
                      timerNames: timerNames,
                      updateName: updateTimerName);
                },
              );
            }).toList(),
            options: CarouselOptions(
              height: 250,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  selectedIndex = index;
                });
                timerIndictorController.animateToPage(
                  index - 1,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  _showTimePicker(context);
                },
                icon: const Icon(Icons.add_alarm_sharp),
                iconSize: 40.0,
                color: Colors.tealAccent,
              ),
              IconButton(
                onPressed: () {
                  _removeTimer(selectedIndex);
                },
                icon: const Icon(Icons.delete_forever_sharp),
                iconSize: 40.0,
                color: Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
