import 'dart:async';

import 'package:douyin/douyin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initState = "none";
  String _code = "";
  String _clientKey = "";
  final _douyinPlugin = Douyin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    authorResultState();
  }

  void authorResultState() {
    _douyinPlugin.respStream().listen((event) {
      setState(() {
        _code = event.authCode;
      });
    });
  }

  Future<void> initPlatformState() async {
    String initState;
    initState = await _douyinPlugin.registerDouyinApp(apiKey: _clientKey);
    if (!mounted) return;

    setState(() {
      _initState = initState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_initState\n----$_code'),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    _douyinPlugin.authorLogin(
                      scopeKey: "trial.whitelist,user_info",
                    );
                  },
                  child: const Text('授权登录')),
            )
          ],
        ),
      ),
    );
  }
}
