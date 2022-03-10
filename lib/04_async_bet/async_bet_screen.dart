import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_m02_r03_async/04_async_bet/async_bet_line_widget.dart';

import 'lines.dart';

const lineHeight = 600.0;

class AsyncBetScreen extends StatefulWidget {
  const AsyncBetScreen({Key? key}) : super(key: key);

  @override
  State<AsyncBetScreen> createState() => _AsyncBetScreenState();
}

class _AsyncBetScreenState extends State<AsyncBetScreen> {
  var lineRed = 0;
  void setLineRed(int value) => setState(() => lineRed = value);

  var linePurple = 0;
  void setLinePurple(int value) => setState(() => linePurple = value);

  var lineBlue = 0;
  void setLineBlue(int value) => setState(() => lineBlue = value);

  bool get notWinner => lineRed < 100 && lineBlue < 100 && linePurple < 100;

  StreamSubscription? subscription;

  Future<String> runGame() async {
    setLineBlue(0);
    setLinePurple(0);
    setLineRed(0);

    final random = Random();
    while (notWinner) {
      setLineBlue(lineBlue + random.nextInt(10));
      setLinePurple(linePurple + random.nextInt(10));
      setLineRed(lineRed + random.nextInt(10));
      await Future.delayed(const Duration(milliseconds: 200));
    }
    if (lineRed >= 100) return 'VERMELHO';
    if (lineBlue >= 100) return 'AZUL';
    if (linePurple >= 100) return 'ROXO';
    return '';
  }

  final lines = Lines();

  Stream<Lines> runLines() async* {
    lines.clear();
    yield lines;
    final random = Random();
    while (lines.notWinner) {
      lines.incrementBlue(random.nextInt(10));
      lines.incrementPurple(random.nextInt(10));
      lines.incrementRed(random.nextInt(10));
      yield lines;
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void onStart() {
    subscription = runLines().listen(
      (lines) {
        setState(() {
          lineBlue = lines.blue;
          lineRed = lines.red;
          linePurple = lines.purple;
        });

        if (lines.winner != null) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Text('${lines.winner!.toLowerCase()} venceu!'),
            ),
          );
        }
      },
      onDone: () {
        print('Finalizou');
      },
      onError: (error) {},
    );
  }

  void onCancel() {
    subscription?.cancel();
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        content: Text('Cancelou'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: const Text('AsyncBet'),
        actions: [
          ElevatedButton(
            child: const Text('stop'),
            onPressed: onCancel,
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            child: const Text('start'),
            onPressed: onStart,
          ),
        ],
      ),
      body: SizedBox(
        height: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AsyncBetLineWidget(
              height: lineHeight,
              color: Colors.red,
              progress: lineRed,
            ),
            AsyncBetLineWidget(
              height: lineHeight,
              color: Colors.deepPurple,
              progress: linePurple,
            ),
            AsyncBetLineWidget(
              height: lineHeight,
              color: Colors.blue,
              progress: lineBlue,
            ),
          ],
        ),
      ),
    );
  }
}
