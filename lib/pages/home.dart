import 'package:flutter/material.dart';
import 'package:Fastlead/theme.dart';
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
  TextEditingController _textEditingController = TextEditingController();
  String _webviewUrl = "http://192.168.100.13:8765/";
  late WebViewController controller;
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

  // update 15/06/2023
  int _timeInterval = 2;

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

  // untuk sensor 1
  Future<void> _toggleOnLED1() async {
    String url = 'http://192.168.100.120/ON';
    String url1 = 'http://192.168.100.122/onA';

    try {
      await Future.wait([http.get(Uri.parse(url)), http.get(Uri.parse(url1))]);
    } catch (e) {
      print('Failed to toggle LED: $e');
    }
  }

  //untuk kotak utama
  // Future<void> _toggleOnLED3() async {
  //   String url = 'http://192.168.100.122/onA';

  //   try {
  //     await http.get(Uri.parse(url));
  //   } catch (e) {
  //     print('Failed to toggle LED: $e');
  //   }
  // }

  // untuk sensor 1
  Future<void> _toggleOffLED1() async {
    String url = 'http://192.168.100.120/OFF';
    String url1 = 'http://192.168.100.120/offA';

    try {
      await Future.wait([http.get(Uri.parse(url)), http.get(Uri.parse(url1))]);
    } catch (e) {
      print('Failed to toggle LED: $e');
    }
  }

  // kotak utama
  // Future<void> _toggleOffLED3() async {
  //   String url = 'http://192.168.100.122/offA';

  //   try {
  //     await http.get(Uri.parse(url));
  //   } catch (e) {
  //     print('Failed to toggle LED: $e');
  //   }
  // }

  // untuk sensor 2
  Future<void> _toggleOnLED2() async {
    String url = 'http://192.168.100.121/ON';
    String url1 = 'http://192.168.100.122/onB';

    try {
      await Future.wait([http.get(Uri.parse(url)), http.get(Uri.parse(url1))]);
    } catch (e) {
      print('Failed to toggle LED: $e');
    }
  }

  // untuk kotak utama
  // Future<void> _toggleOnLED4() async {
  //   String url = 'http://192.168.100.122/onB';

  //   try {
  //     await http.get(Uri.parse(url));
  //   } catch (e) {
  //     print('Failed to toggle LED: $e');
  //   }
  // }

  // untuk sensor 2
  Future<void> _toggleOffLED2() async {
    String url = 'http://192.168.100.121/OFF';
    String url1 = 'http://192.168.100.121/offB';

    try {
      await Future.wait([http.get(Uri.parse(url)), http.get(Uri.parse(url1))]);
      ;
    } catch (e) {
      print('Failed to toggle LED: $e');
    }
  }

  // untuk kotak utama
  // Future<void> _toggleOffLED4() async {
  //   String url = 'http://192.168.100.122/offB';

  //   try {
  //     await http.get(Uri.parse(url));
  //   } catch (e) {
  //     print('Failed to toggle LED: $e');
  //   }
  // }

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
        _toggleOnLED1();
        // _toggleOffLED3();
      } else {
        // _toggleOffLED();
        _toggleOnLED2();
        // _toggleOnLED4();
      }
      _setAutoModeStatus(false);
      return _autoMode();
    } else {
      _setAutoModeStatus(false);
    }
  }

  Future _randomOperation() {
    return Future.delayed(Duration(seconds: _timeInterval));
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

  // update input ip camera
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change IP Camera'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  _webviewUrl = value;
                });
              },
              controller: _textEditingController,
              decoration: InputDecoration(hintText: "$_webviewUrl"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: primaryColor,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    controller.loadUrl(_webviewUrl);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _webviewUrl,
                    onWebViewCreated: (WebViewController webViewController) {
                      controller = webViewController;
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(orangeColor),
                            padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 12),
                            ),
                            // shape: MaterialStatePropertyAll(
                            //   RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(8),
                            //   ),
                            // ),
                          ),
                          onPressed: () {
                            _displayTextInputDialog(context);
                          },
                          child: Text(
                            'Change IP Camera',
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
                          onPressed: () {
                            _toggleOffLED1();
                            // _toggleOffLED3();
                          },
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
                          onPressed: () {
                            _toggleOnLED1();
                            // _toggleOnLED3();
                          },
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
                          onPressed: () {
                            _toggleOffLED2();
                            // _toggleOffLED4();
                          },
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
                          onPressed: () {
                            _toggleOnLED2();
                            // _toggleOnLED4();
                          },
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
                  'Random Interval (Seconds): $_timeInterval',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: Text(
                          '2s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        value: 2,
                        fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white,
                        ),
                        groupValue: _timeInterval,
                        onChanged: (int? value) {
                          setState(() {
                            _timeInterval = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text(
                          '3s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        value: 3,
                        fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white,
                        ),
                        groupValue: _timeInterval,
                        onChanged: (int? value) {
                          setState(() {
                            _timeInterval = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text(
                          '5s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        value: 5,
                        fillColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white,
                        ),
                        groupValue: _timeInterval,
                        onChanged: (int? value) {
                          setState(() {
                            _timeInterval = value!;
                          });
                        },
                      ),
                    ),
                  ],
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
