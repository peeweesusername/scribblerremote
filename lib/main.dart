import 'package:flutter/material.dart';
import 'package:scribblerremote/scribblercomms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Scribbler Remote'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late ScribblerComms _myScribbler;

  void _beep() {
    if (_myScribbler.notConnected()) {
      _myScribbler.openFirstFoundComms();
      return;
    }
    _myScribbler.beep();
  }

  void _forward() {
    if (_myScribbler.notConnected()) {
      _myScribbler.openFirstFoundComms();
      return;
    }
    _myScribbler.forward();
  }

  void _reverse() {
    if (_myScribbler.notConnected()) {
      _myScribbler.openFirstFoundComms();
      return;
    }
    _myScribbler.reverse();
  }

  void _left() {
    if (_myScribbler.notConnected()) {
      _myScribbler.openFirstFoundComms();
      return;
    }
    _myScribbler.left();
  }

  void _right() {
    if (_myScribbler.notConnected()) {
      _myScribbler.openFirstFoundComms();
      return;
    }
    _myScribbler.right();
  }

  void _stop() {
    if (_myScribbler.notConnected()) {
      _myScribbler.openFirstFoundComms();
      return;
    }
    _myScribbler.stop();
  }

  @override
  void initState()  {
    super.initState();
    _myScribbler = ScribblerComms();
    _myScribbler.scanForFirstScribbler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: _forward,
                  tooltip: 'Forward',
                  child: const Icon(Icons.arrow_upward),
                ),
              ]
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _left,
                    tooltip: 'Left',
                    child: const Icon(Icons.arrow_back),
                  ),
                  FloatingActionButton(
                    onPressed: _stop,
                    tooltip: 'Stop',
                    child: const Icon(Icons.stop_circle),
                  ),
                  FloatingActionButton(
                    onPressed: _right,
                    tooltip: 'Right',
                    child: const Icon(Icons.arrow_forward),
                  ),
                ]
            ),
            FloatingActionButton(
              onPressed: _reverse,
              tooltip: 'Reverse',
              child: const Icon(Icons.arrow_downward),
            ),
            FloatingActionButton(
              onPressed: _beep,
              tooltip: 'Beep',
              child: const Icon(Icons.music_note),
            ),
          ],
        ),
      ),
    );
  }
}
