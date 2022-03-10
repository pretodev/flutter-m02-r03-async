import 'package:flutter/material.dart';
import 'package:flutter_m02_r03_async/04_async_bet/async_bet_screen.dart';

class AsyncBetApp extends StatelessWidget {
  const AsyncBetApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AsyncBetScreen(),
    );
  }
}
