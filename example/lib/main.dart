import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hh_screen_recorder/hh_screen_recorder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _hhScreenRecorderPlugin = HhScreenRecorder();

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _hhScreenRecorderPlugin.startRecording(filename: "test");
                },
                child: Text(
                  "Test",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _hhScreenRecorderPlugin.stopRecording();
                },
                child: Text(
                  "Stop Test",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _hhScreenRecorderPlugin.getFilePath();
                },
                child: Text(
                  "Stop Test",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
