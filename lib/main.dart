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
  late RCPanel myRCpanel;
  //late ScannerPanel myScannerPanel;
  //late StatefulScannerPanel mySFScannerPanel;

  void _doScan() {
    print('scanning');
    _scribblerIsFound = false;
    _scribblerScanner = ScribblerScanner(foundScribbler, connected2Scribbler);
    _scribblerScanner.scanForFirstScribbler();
    _scribblerScanner.scanForScribblers(_scribblers);
  }

  void foundScribbler() {
    print('called back - found scribbler');
    setState(() {
      _scribblerIsFound = true;
    });
  }

  void connected2Scribbler() {
    print('called back - connected to scribbler');
    setState(() {
      _scribblerIsConnected = true;
      //myScannerPanel.isConnected = true;
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
    myRCpanel = RCPanel(
      _forward,
      _left,
      _right,
      _stop,
      _reverse,
      _beep,
    );
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
            //myScannerPanel,
            StatefulScannerPanel(
                doScan: _doScan,
                isConnected: _scribblerIsConnected
            ),
            myRCpanel,
          ],
        ),
      ),
    );
  }
}

class StatefulScannerPanel extends StatefulWidget {
  final VoidCallback doScan;
  final bool isConnected;
  const StatefulScannerPanel({
    super.key,
    required this.doScan,
    required this.isConnected});

  @override
  State<StatefulScannerPanel> createState() => _StatefulScannerPanel();
}

class _StatefulScannerPanel extends State<StatefulScannerPanel> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.isConnected ? const Text('connected') : const Text('not connected'),
        FloatingActionButton(
          onPressed: widget.doScan,
          tooltip: 'Scan',
          child: const Icon(Icons.search),
        ),
      ],);
  }
}
/*
class ScannerPanel extends StatelessWidget {
  final VoidCallback doScan;
  bool isConnected;

  ScannerPanel(this.doScan, this.isConnected, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        isConnected ? const Text('connected') : const Text('not connected'),
        FloatingActionButton(
          onPressed: doScan,
          tooltip: 'Scan',
          child: const Icon(Icons.search),
        ),
      ],);
  }
}
*/

class RCPanel extends StatelessWidget {
  final VoidCallback forward;
  final VoidCallback left;
  final VoidCallback right;
  final VoidCallback stop;
  final VoidCallback reverse;
  final VoidCallback beep;
  const RCPanel(
      this.forward,
      this.left,
      this.right,
      this.stop,
      this.reverse,
      this.beep,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: forward,
              tooltip: 'Forward',
              child: const Icon(Icons.arrow_upward),
            ),
          ]
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                onPressed: left,
                tooltip: 'Left',
                child: const Icon(Icons.arrow_back),
              ),
              FloatingActionButton(
                onPressed: stop,
                tooltip: 'Stop',
                child: const Icon(Icons.stop_circle),
              ),
              FloatingActionButton(
                onPressed: right,
                tooltip: 'Right',
                child: const Icon(Icons.arrow_forward),
              ),
            ]
        ),
        FloatingActionButton(
          onPressed: reverse,
          tooltip: 'Reverse',
          child: const Icon(Icons.arrow_downward),
        ),
        FloatingActionButton(
          onPressed: beep,
          tooltip: 'Beep',
          child: const Icon(Icons.music_note),
        ),
      ],
    );
  }
}

