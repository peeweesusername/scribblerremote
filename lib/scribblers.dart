import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart' as netinfo;
import 'package:network_tools/network_tools.dart';

class Scribbler {
  late final String _name;
  late final String _ipAddress;
  late Socket _tcpSocket;
  bool _notConnected = true;
  Scribbler (this._name, this._ipAddress);

  Future<void> openConnection () async {
    if (_notConnected) {
      _tcpSocket = await Socket.connect(_ipAddress, 23);
      _notConnected = false;
    }
  }

  String get name {
    return _name;
  }

  String get ip {
    return _ipAddress;
  }

  bool get notConnected {
    return _notConnected;
  }

  void beep () {
    _tcpSocket.add(utf8.encode('B'));
  }

  void forward () {
    _tcpSocket.add(utf8.encode('F'));
  }

  void reverse () {
    _tcpSocket.add(utf8.encode('R'));
  }

  void left () {
    _tcpSocket.add(utf8.encode('l'));
  }

  void right () {
    _tcpSocket.add(utf8.encode('r'));
  }

  void stop () {
    _tcpSocket.add(utf8.encode('S'));
  }
}

class ScribblerScanner {
  VoidCallback foundScribbler;
  VoidCallback connected2Scribbler;
  ScribblerScanner(this.foundScribbler, this.connected2Scribbler);

  late Socket _tcpSocket;
  bool _socketNotConnected = true;
  bool _scribblerFound = false;
  String _scribblerIP = '127.0.0.1';

  Future<void> openComms (String ipAddress) async {
    if (_socketNotConnected) {
      _tcpSocket = await Socket.connect(ipAddress, 23);
      _socketNotConnected = false;
      connected2Scribbler();
    }
  }

  Future<void> openFirstFoundComms () async {
    if ((_socketNotConnected) && (_scribblerFound)) {
      _tcpSocket = await Socket.connect(_scribblerIP, 23);
      _socketNotConnected = false;
      connected2Scribbler();
    }
  }

  Future<String> readModuleName (String ipAddress) async {
    //HTTP read from http://ipAddress/wx/setting?name=module-name
    String modeName;
    try {
      modeName =  await http.read(Uri.http(ipAddress, '/wx/setting', {'name' : 'module-name'}));
    }
    catch (e) {
      modeName = 'notAScribbler';
    }
    return modeName;
  }

  Future<void> scanForFirstScribbler () async {
    final myNetInfo = netinfo.NetworkInfo();
    var myIP = await myNetInfo.getWifiIP();

    late String? subnet = myIP?.substring(0, myIP.lastIndexOf('.'));

    //This does not complete synchronously, onDone is hit before scribbler is found
    final stream = HostScanner.scanDevicesForSinglePort(subnet!, 80, firstHostId: 1, lastHostId: 255);
    stream.listen((host)  async {
      var ip2Test = host.internetAddress.address.toString();
      var moduleName = await readModuleName(ip2Test);
      if (moduleName != 'notAScribbler') {
        _scribblerIP = ip2Test;
        _scribblerFound = true;
        print('found $moduleName $_scribblerIP');
        }
      },
        onDone: () {
      });
  }

  Future<void> scanForScribblers (List<Scribbler> scribblers) async {
    final myNetInfo = netinfo.NetworkInfo();
    var myIP = await myNetInfo.getWifiIP();

    late String? subnet = myIP?.substring(0, myIP.lastIndexOf('.'));

    //This does not complete synchronously, onDone is hit before scribbler is found
    final stream = HostScanner.scanDevicesForSinglePort(subnet!, 80, firstHostId: 1, lastHostId: 255);

    stream.listen((host)  async {
      var ip2Test = host.internetAddress.address.toString();
      var moduleName = await readModuleName(ip2Test);
      if (moduleName != 'notAScribbler') {
        scribblers.add(Scribbler(moduleName,ip2Test));
        foundScribbler();
        print('found $moduleName $ip2Test');
      }
    },

    onDone: () {
    });
  }

  bool notConnected() {
    return _socketNotConnected;
  }

  void beep () {
    _tcpSocket.add(utf8.encode('B'));
  }

  void forward () {
    _tcpSocket.add(utf8.encode('F'));
  }

  void reverse () {
    _tcpSocket.add(utf8.encode('R'));
  }

  void left () {
    _tcpSocket.add(utf8.encode('l'));
  }

  void right () {
    _tcpSocket.add(utf8.encode('r'));
  }

  void stop () {
    _tcpSocket.add(utf8.encode('S'));
  }

}