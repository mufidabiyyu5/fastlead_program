import 'package:flutter/material.dart';
import 'package:fastlead/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _webviewUrl = "http://192.168.100.141/";
  final _key = UniqueKey();
  String? _localIP = 'Unknown';

  @override
  void initState() {
    super.initState();
    _getLocalIP();
  }

  Future<void> _getLocalIP() async {
    String? localIP = await NetworkInfo().getWifiIP();
    setState(() {
      _localIP = localIP;
    });
  }

  Future<void> _toggleOnLED() async {
    String url1 = 'http://192.168.100.110/on14';
    String url2 = 'http://192.168.100.115/on20';
    await http.get(Uri.parse(url1));
    await http.get(Uri.parse(url2));
  }

  Future<void> _toggleOffLED() async {
    String url1 = 'http://192.168.100.110/off14';
    String url2 = 'http://192.168.100.115/off20';
    await http.get(Uri.parse(url1));
    await http.get(Uri.parse(url2));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset(
                'assets/logo.png',
                width: 64,
                height: 64,
                alignment: Alignment.center,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
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
                  SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(orangeColor),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
