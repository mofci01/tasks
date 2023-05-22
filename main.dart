import 'package:flutter/material.dart';
import 'dart:async';
import 'package:light/light.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Light Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Task(),
    );
  }
}


class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {

  int luxValue = 0;
  late Light light;
  late StreamSubscription subscription;

  void onData(int lux) async {
    debugPrint("Lux value: $luxValue");
    setState(() {
      luxValue = lux;
    });
  }
  void stopListening() {
    subscription.cancel();
  }
  void startListening() {
    light = Light();
    try {
      subscription = light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      debugPrint(exception.toString());
    }
  }

  // start from here
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: luxValue < 20 ?  Colors.black :  Colors.white,
        body: Center(
          child: Text(
            'Hello World',
            style: TextStyle(color: luxValue < 20 ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

