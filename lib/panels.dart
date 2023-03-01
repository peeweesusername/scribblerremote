import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scribblerremote/scribblers.dart';

class StatusPanel extends StatelessWidget {
  final bool isConnected;
  final bool isScanning;
  final String scribblerName;

  const StatusPanel({
    super.key,
    required this.isConnected,
    required this.isScanning,
    required this.scribblerName});

  @override
  Widget build(BuildContext context) {
    if (isScanning){
      return const Text('Scanning...');
    }
    else {
      return isConnected ? Text('Connected To $scribblerName') : const Text('Not Connected');
    }
  }
}

class ScannerPanel extends StatelessWidget {
  final VoidCallback doScan;
  final bool isScanning;

  const ScannerPanel({
    super.key,
    required this.doScan,
    required this.isScanning});

  @override
  Widget build(BuildContext context) {
    if (isScanning){
      return SpinKitFadingCircle(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.blue : Colors.green,
            ),
          );
        },
      );
    }
    else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton.extended(
            onPressed: doScan,
            tooltip: 'Scan',
            label: const Text('Scan For Scribblers'),
          ),
        ],);
    }
  }
}

class SelectionMenuPanel extends StatelessWidget {
  final List<Scribbler> scribblers;
  final Function connected2Scribbler;

  SelectionMenuPanel({
    super.key,
    required this.scribblers,
    required this.connected2Scribbler});

  final List<PopupMenuItem> _menuItems = [];

  @override
  Widget build(BuildContext context) {

    for (var robot in scribblers) {
      _menuItems.add(PopupMenuItem(value: _menuItems.length, child: Text(robot.name)));
    }

    return PopupMenuButton(
      onSelected: (value) {
        scribblers[value].openConnection(connected2Scribbler, context);
      },
      itemBuilder:  (BuildContext context) {
        return _menuItems;
      },
      child: Container(
          decoration: const ShapeDecoration(
              color: Colors.green,
              shape: StadiumBorder(
                side: BorderSide(color: Colors.green, width: 10),
              )
          ),
          child: const Text(
              'Tap To Select Robot',
              style: TextStyle(color: Colors.white, fontSize: 15)),
      )
    );
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
