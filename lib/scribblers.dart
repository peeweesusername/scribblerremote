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
  Scribbler (this._name, this._ipAddress);

  late Socket _tcpSocket;
  bool _notConnected = true;

  Future<void> openConnection (Function connected) async {
    if (_notConnected) {
      _tcpSocket = await Socket.connect(_ipAddress, 23);
      _notConnected = false;
      connected(this);
    }
  }

  String get name {
    return _name;
  }

  set name(String str) {
    _name = str;
  }

  String get ip {
    return _ipAddress;
  }

  set ip (String addr) {
    _ipAddress = addr;
  }

  bool get notConnected {
    return _notConnected;
  }

  void disconnect() {
    _tcpSocket.flush();
    _tcpSocket.destroy();
    _notConnected = true;
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
  VoidCallback doneScanning;
  ScribblerScanner({
    required this.foundScribbler,
    required this.doneScanning});

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
        scribblers.add(Scribbler(moduleName, ip2Test));
        //Uncomment to test scrollable selection menu
        /*
        scribblers.add(Scribbler('fake 1', '127.0.0.1'));
        scribblers.add(Scribbler('fake 2', '127.0.0.1'));
        scribblers.add(Scribbler('fake 3', '127.0.0.1'));
        scribblers.add(Scribbler('fake 4', '127.0.0.1'));
        scribblers.add(Scribbler('fake 5', '127.0.0.1'));
        scribblers.add(Scribbler('fake 7', '127.0.0.1'));
        scribblers.add(Scribbler('fake 8', '127.0.0.1'));
        scribblers.add(Scribbler('fake 9', '127.0.0.1'));
        scribblers.add(Scribbler('fake 10', '127.0.0.1'));
        scribblers.add(Scribbler('fake 11', '127.0.0.1'));
        scribblers.add(Scribbler('fake 13', '127.0.0.1'));
        scribblers.add(Scribbler('fake 14', '127.0.0.1'));
        scribblers.add(Scribbler('fake 15', '127.0.0.1'));
        scribblers.add(Scribbler('fake 16', '127.0.0.1'));
        scribblers.add(Scribbler('fake 17', '127.0.0.1'));
        scribblers.add(Scribbler('fake 18', '127.0.0.1'));
        scribblers.add(Scribbler('fake 19', '127.0.0.1'));
        */
        foundScribbler();
      }
    },

    onDone: () {
      doneScanning();
    });
  }

}