import 'package:flutter/material.dart';

class AsyncBetLineWidget extends StatelessWidget {
  final double height;
  final Color color;
  final int progress;

  const AsyncBetLineWidget({
    Key? key,
    required this.height,
    required this.color,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var correctProgress = progress > 100 ? 100 : progress;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 50.0,
          height: height,
          color: Colors.grey[300],
        ),
        Container(
          width: 50.0,
          height: height / 100 * correctProgress,
          color: color,
        ),
      ],
    );
  }
}
