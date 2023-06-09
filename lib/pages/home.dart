import 'package:flutter/material.dart';
import 'package:fastlead/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math';

class Home extends StatefulWidget {
  const Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _webviewUrl = "http://192.168.100.13:8765/";
  final _key = UniqueKey();
  String? _localIP = 'Unknown';

  //update 06/06/23
  String _startStop = "Stop";
  bool _stopwatchStatus = true;
  String _elapsedTime = "00:00:00.00";
  Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;

  //update 08/06/2023
  int randomNumber = 0;
  bool _autoModeStatus = false;
  bool _randomProgress = false;

  @override
  void initState() {
    super.initState();
    _getLocalIP();
    _startStopwatch();
  }

  Future<void> _getLocalIP() async {
    String? localIP = await NetworkInfo().getWifiIP();
    setState(() {
      _localIP = localIP;
    });
  }

  Future<void> _toggleOnLED() async {
    String url = '192.168.100.120';

    await http.get(Uri.http(url, '/ON'));
  }

  Future<void> _toggleOffLED() async {
    String url = '192.168.100.120';

    await http.get(Uri.http(url, '/OFF'));
  }

  Future<void> _toggleOnLED1() async {
    String url = '192.168.100.121';

    await http.get(Uri.http(url, '/ON'));
  }

  Future<void> _toggleOffLED1() async {
    String url = '192.168.100.121';

    await http.get(Uri.http(url, '/OFF'));
  }

  //update 06/06/23
  void _changeStopwatchStatus(bool status) {
    if (status) {
      _stopStopwatch();
      _startStop = 'Start';
    } else {
      _startStopwatch();
      _startStop = 'Stop';
    }
  }

  void _startStopwatch() {
    _stopwatch.start();
    _stopwatchStatus = true;
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {
        _elapsedTime = _stopwatch.elapsed.toString().substring(0, 8);
      });
    });
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _stopwatchStatus = false;
    _timer.cancel();
  }

  void _resetStopwatch() {
    _stopwatch.stop();
    _stopwatch.reset();
    _stopwatchStatus = false;
    _startStop = 'Start';
    _timer.cancel();
    setState(() {
      _elapsedTime = "00:00:00.00";
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  //update 08/06/2023
  _autoMode() async {
    if (_randomProgress) {
      _randomProgress = false;
      _setAutoModeStatus(false);
      return;
    }

    _randomProgress = true;
    _setAutoModeStatus(true);
    await _randomOperation();
    Random random = new Random();
    randomNumber = random.nextInt(10);

    if (_randomProgress) {
      _randomProgress = false;
      if (randomNumber % 2 == 0) {
        // _toggleOffLED1();
        _toggleOnLED();
      } else {
        // _toggleOffLED();
        _toggleOnLED1();
      }
      _setAutoModeStatus(false);
      return _autoMode();
    } else {
      _setAutoModeStatus(false);
    }
  }

  Future _randomOperation() {
    return Future.delayed(const Duration(seconds: 3));
  }

  // void _changeRandomProgress() {
  //   if (_randomProgress) {
  //     _randomProgress = false;
  //     _autoMode();
  //   } else {
  //     _randomProgress = true;
  //   }
  // }

  void _setAutoModeStatus(bool status) {
    setState(() {
      _autoModeStatus = status;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/logo.png',
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _webviewUrl,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$_elapsedTime',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Sensor 1",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 12),
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: _toggleOffLED,
                          child: Text(
                            'Off',
                            style: TextStyle(
                              color: orangeColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(orangeColor),
                            padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 12),
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: _toggleOnLED,
                          child: Text(
                            'On',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Sensor 2",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 12),
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: _toggleOffLED1,
                          child: Text(
                            'Off',
                            style: TextStyle(
                              color: orangeColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(orangeColor),
                            padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 12),
                            ),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: _toggleOnLED1,
                          child: Text(
                            'On',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Wifi IP: $_localIP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Auto Mode: $randomNumber',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 12),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () => _autoMode(),
                    child: Text(
                      _autoModeStatus ? 'Stop Auto Mode' : 'Start Auto Mode',
                      style: TextStyle(
                        color: orangeColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Stopwatch Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 12),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: _resetStopwatch,
                        child: Text(
                          'Reset',
                          style: TextStyle(
                            color: orangeColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(orangeColor),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 12),
                          ),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () =>
                            _changeStopwatchStatus(_stopwatchStatus),
                        child: Text(
                          '$_startStop',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
