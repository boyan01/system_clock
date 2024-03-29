import 'package:flutter/material.dart';
import 'package:system_clock/system_clock.dart';

void main() {
  runApp(const MyApp());
}

DateTime _lastBootDatetime() {
  final bootSinceEpoch = DateTime.now().microsecondsSinceEpoch -
      SystemClock.elapsedRealtime().inMicroseconds;
  return DateTime.fromMicrosecondsSinceEpoch(bootSinceEpoch);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 30),
    );
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ListView(
            children: [
              ListTile(
                title: Text("uptime: ${SystemClock.uptime()}"),
                onTap: () {},
              ),
              ListTile(
                title:
                    Text("elapsedRealtime: ${SystemClock.elapsedRealtime()}"),
                subtitle: Text("last boot: ${_lastBootDatetime()}"),
                onTap: () {},
              ),
            ],
          )),
    );
  }
}
