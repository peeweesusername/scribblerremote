import 'package:flutter/material.dart';

class ScannerPanel extends StatelessWidget {
  final VoidCallback doScan;
  final bool isConnected;

  const ScannerPanel({
    super.key,
    required this.doScan,
    required this.isConnected});

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
