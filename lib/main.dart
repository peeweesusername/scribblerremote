import 'package:flutter/material.dart';
import 'package:scribblerremote/scribblers.dart';
import 'package:scribblerremote/panels.dart';

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
            ScannerPanel(
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

