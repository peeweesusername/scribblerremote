import 'package:flutter/material.dart';
import 'package:scribblerremote/scribblers.dart';

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
      home: const ScribblerRemote(title: 'Scribbler Remote'),
    );
  }
}

class ScribblerRemote extends StatefulWidget {
  const ScribblerRemote({super.key, required this.title});

  final String title;
  @override
  State<ScribblerRemote> createState() => _ScribblerRemoteState();
}

class _ScribblerRemoteState extends State<ScribblerRemote> {

  late ScribblerScanner _scribblerScanner;
  late Scribbler _connectedScribbler;
  bool _scribblerIsFound = false;
  bool _scribblerIsConnected = false;
  final List<Scribbler> _scribblers = [];

  void _doScan() {
    print('scanning');
    _scribblerIsFound = false;
    _scribblerScanner = ScribblerScanner(foundScribbler);
    _scribblerScanner.scanForFirstScribbler();
    _scribblerScanner.scanForScribblers(_scribblers);
  }

  void foundScribbler() {
    print('called back - found scribbler');
    setState(() {
      _scribblerIsFound = true;
    });
  }

  void _beep() {
    for (var robot in _scribblers) {
      print('${robot.name} @ ${robot.ip}');
    }
    if (_scribblerScanner.notConnected()) {
      _scribblerScanner.openFirstFoundComms();
      return;
    }
    _scribblerScanner.beep();
  }

  void _forward() {
    if (_scribblerScanner.notConnected()) {
      _scribblerScanner.openFirstFoundComms();
      return;
    }
    _scribblerScanner.forward();
  }

  void _reverse() {
    if (_scribblerScanner.notConnected()) {
      _scribblerScanner.openFirstFoundComms();
      return;
    }
    _scribblerScanner.reverse();
  }

  void _left() {
    if (_scribblerScanner.notConnected()) {
      _scribblerScanner.openFirstFoundComms();
      return;
    }
    _scribblerScanner.left();
  }

  void _right() {
    if (_scribblerScanner.notConnected()) {
      _scribblerScanner.openFirstFoundComms();
      return;
    }
    _scribblerScanner.right();
  }

  void _stop() {
    if (_scribblerScanner.notConnected()) {
      _scribblerScanner.openFirstFoundComms();
      return;
    }
    _scribblerScanner.stop();
  }

  @override
  void initState()  {
    super.initState();
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
            FloatingActionButton(
              onPressed: _doScan,
              tooltip: 'Scan',
              child: const Icon(Icons.search),
            ),
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
            _scribblerIsConnected? const Text('connected') : const Text('not connected')
          ],
        ),
      ),
    );
  }
}

