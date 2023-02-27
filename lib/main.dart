import 'package:flutter/material.dart';
import 'package:scribblerremote/scribblers.dart';
import 'package:scribblerremote/panels.dart';

void main() {
  runApp(const ScribblerRemoteApp());
}

class ScribblerRemoteApp extends StatelessWidget {
  const ScribblerRemoteApp({super.key});

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

  bool _scribblerIsFound = false;
  bool _scribblerIsConnected = false;
  bool _scanningForScribblers = false;
  Scribbler _connectedScribbler = Scribbler('NotConnected', '127.0.0.1');
  late RCPanel _myRCpanel;
  late ScribblerScanner _scribblerScanner;
  final List<Scribbler> _scribblers = [];

  void _foundScribbler() {
    print('called back - found scribbler');
    for (var robot in _scribblers) {
      print('${robot.name} @ ${robot.ip}');
    }
    setState(() {
      _scribblerIsFound = true;
    });
  }

  void _connected2Scribbler(Scribbler scribbler) {
    print('called back - connected to scribbler');
    setState(() {
      _scribblerIsConnected = true;
      _connectedScribbler = scribbler;
    });
  }

  void _scanningDone() {
    setState(() {
      _scanningForScribblers = false;
    });
  }

  void _doScan() {
    print('scanning');
    if (_scribblerIsConnected) {
      _connectedScribbler.disconnect();
    }
    _scribblers.clear();
    setState(() {
      _scribblerIsFound = false;
      _scribblerIsConnected = false;
      _scanningForScribblers = true;
    });
    _scribblerScanner.scanForScribblers(_scribblers);
  }

  void _beep() {
    _connectedScribbler.beep();
  }

  void _forward() {
    _connectedScribbler.forward();
  }

  void _reverse() {
    _connectedScribbler.reverse();
  }

  void _left() {
    _connectedScribbler.left();
  }

  void _right() {
    _connectedScribbler.right();
  }

  void _stop() {
    _connectedScribbler.stop();
  }

  @override
  void initState()  {
    super.initState();
    _scribblerScanner = ScribblerScanner(
        foundScribbler: _foundScribbler,
        doneScanning: _scanningDone);
    _myRCpanel = RCPanel(
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
            StatusPanel(
                isConnected: _scribblerIsConnected,
                isScanning: _scanningForScribblers,
                scribblerName: _connectedScribbler.name),
            ScannerPanel(
              doScan: _doScan,
              isScanning: _scanningForScribblers,
            ),
            (_scribblerIsFound && !_scribblerIsConnected) ? SelectPanel(
              scribblers: _scribblers,
              connected2Scribbler: _connected2Scribbler,
            ) : Container(),
            _scribblerIsConnected ? _myRCpanel : Container(),
          ],
        ),
      ),
    );
  }
}

