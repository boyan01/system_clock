import 'package:flutter/material.dart';
import 'package:system_clock/system_clock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('SystemUpTimes: ${SystemClock.uptime}'),
        ),
      ),
    );
  }
}
