import 'dart:async';

import 'package:flutter/material.dart';

class PomodoroTaskApp extends StatelessWidget {
  const PomodoroTaskApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const PomodoroTaskScreen(),
    );
  }
}

enum PomodoroState {
  none,
  work,
  rest,
  restStarted,
}

class PomodoroTaskScreen extends StatefulWidget {
  const PomodoroTaskScreen({Key? key}) : super(key: key);

  @override
  State<PomodoroTaskScreen> createState() => _PomodoroTaskScreenState();
}

class _PomodoroTaskScreenState extends State<PomodoroTaskScreen> {
  var timerSeconds = 5;
  var pomodoroState = PomodoroState.none;
  var currentTask = 'Adicionar tarefa+';

  void startPomodoro() {
    changeState();
    timerSeconds = pomodoroState == PomodoroState.work ? 15 : 5;
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timerSeconds == 0) {
          timer.cancel();
          changeState();
          return;
        }
        setState(() => timerSeconds -= 1);
      },
    );
  }

  void changeState() {
    if (pomodoroState == PomodoroState.none ||
        pomodoroState == PomodoroState.restStarted) {
      setState(() => pomodoroState = PomodoroState.work);
      return;
    }

    if (pomodoroState == PomodoroState.work) {
      setState(() => pomodoroState = PomodoroState.rest);
      return;
    }

    if (pomodoroState == PomodoroState.rest) {
      setState(() => pomodoroState = PomodoroState.restStarted);
      return;
    }
  }

  void addTask() async {
    var task = '';
    final taskName = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          onChanged: (value) => task = value,
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Adicionar'),
            onPressed: () {
              Navigator.pop(context, task);
            },
          ),
        ],
      ),
    );
    if (taskName != null) {
      setState(() {
        currentTask = taskName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              child: Text(currentTask),
              onPressed: addTask,
            ),
            PomodoroTimerWidget(
              percent: 100,
              title: 'Pomodoro Task',
              timer: timerSeconds,
              state: pomodoroState,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              child: const Text('Iniciar Pomodoro'),
              onPressed: startPomodoro,
            ),
          ],
        ),
      ),
    );
  }
}

class PomodoroTimerWidget extends StatelessWidget {
  final int percent;
  final String title;
  final int timer;
  final PomodoroState state;

  const PomodoroTimerWidget({
    Key? key,
    required this.percent,
    required this.title,
    required this.timer,
    required this.state,
  }) : super(key: key);

  String get text {
    switch (state) {
      case PomodoroState.none:
        return title;
      case PomodoroState.restStarted:
      case PomodoroState.work:
        return '00:$timer';
      case PomodoroState.rest:
        return 'Descanse!';
    }
  }

  Color get color {
    switch (state) {
      case PomodoroState.none:
        return Colors.grey;
      case PomodoroState.work:
        return Colors.orange;
      case PomodoroState.rest:
      case PomodoroState.restStarted:
        return Colors.lightGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 200,
          width: 200,
          child: CircularProgressIndicator(
            color: color,
            value: percent / 100,
            strokeWidth: 20.0,
          ),
        ),
        Text(text),
      ],
    );
  }
}
