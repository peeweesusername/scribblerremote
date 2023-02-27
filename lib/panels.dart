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
      int i = 0;
      _menuItems.add(PopupMenuItem(value: i++, child: Text(robot.name)));
    }

    //TODO - center menu items, make scrollable,
    // change hamburger buttons to text "Tap To Select Robot"

    return PopupMenuButton(
      onSelected: (value) {
        print ('selected ${scribblers[value].name}');
        scribblers[value].openConnection(connected2Scribbler);
      },
      itemBuilder:  (BuildContext context) {
        return _menuItems;
      },
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
