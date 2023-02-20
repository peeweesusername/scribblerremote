import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart' as netinfo;
import 'package:network_tools/network_tools.dart';

class ScribblerComms {
  late Socket _tcpSocket;
  bool _socketNotConnected = true;
  bool _scribblerFound = false;
  String _scribblerIP = '127.0.0.1';

  Future<void> openComms (String ipAddress) async {
    if (_socketNotConnected) {
      _tcpSocket = await Socket.connect(ipAddress, 23);
      _socketNotConnected = false;
    }
  }

  Future<void> openFirstFoundComms () async {
    if ((_socketNotConnected) && (_scribblerFound)) {
      _tcpSocket = await Socket.connect(_scribblerIP, 23);
      _socketNotConnected = false;
    }
  }

  Future<String> readModuleName (String ipAddress) async {
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
      //Same host can be emitted multiple times
      //Use Set<ActiveHost> instead of List<ActiveHost>
      var ip2Test = host.internetAddress.address.toString();
      var moduleName = await readModuleName(ip2Test);
      if (moduleName != 'notAScribbler') {
        _scribblerIP = ip2Test;
        _scribblerFound = true;
        print('found $moduleName $_scribblerIP');
        }
      },
        onDone: () {
      }); // Don't forget to cancel the stream when not in use.
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

  void stop () {
    _tcpSocket.add(utf8.encode('S'));
  }

}