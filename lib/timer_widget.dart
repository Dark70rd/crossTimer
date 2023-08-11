import 'package:flutter/material.dart';
import 'package:ctimer_prototype_1/timer_logic.dart';

class TimerWidget extends StatefulWidget {
  final StopWatchTimer timer;
  final UpdateCallback onUpdate;
  final int timerIndex;
  final Map<int, String> timerNames;
  final Function(int, String) updateName;

  const TimerWidget(this.timer,
      {super.key,
      required this.onUpdate,
      required this.timerIndex,
      required this.timerNames,
      required this.updateName});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initialName = widget.timerNames[widget.timerIndex];
    nameController.text = initialName ?? "New Timer ${widget.timerIndex + 1}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: 60,
          child: TextField(
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 35.0,
              color: Colors.tealAccent,
            ),
            controller: nameController,
            onChanged: (value) {
              //Handle changes
            },
            onSubmitted: (value) {
              widget.updateName(widget.timerIndex, value);
            },
            decoration: const InputDecoration(
              hintText: "Timer Name",
              border: InputBorder.none,
            ),
          ),
        ),
        //const SizedBox(height: 50,),
        SizedBox(
          height: 104,
          child: Text(
            widget.timer.remainingTime,
            style: const TextStyle(
              fontSize: 75,
              color: Colors.tealAccent,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                if (widget.timer.isActive) {
                  widget.timer.stop();
                } else {
                  widget.timer.start();
                }
              },
              icon: Icon(widget.timer.isActive
                  ? Icons.pause_sharp
                  : Icons.play_arrow_sharp),
              iconSize: 40.0,
              color: Colors.tealAccent,
            ),
            IconButton(
              onPressed: () {
                if (!widget.timer.isActive) {
                  widget.timer.reset();
                }
              },
              icon: const Icon(Icons.restore),
              iconSize: 40.0,
              color: Colors.tealAccent,
            ),
          ],
        )
      ],
    );
  }
}
