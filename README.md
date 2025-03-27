# 抖音授权登录Flutter插件

forked from https://gitee.com/liuxin_dd/douyin

## 功能

#### 支持的API

注册抖音SDK

```dart
Future<String> registerDouyinApp({required String apiKey});
```

授权登录

⚠️`scopeKey`多个类型需要用英文逗号隔开,如`trial.whitelist,user_info`

```dart
Future<String> authorLogin({required String scopeKey});
```

监听授权登录回调

```dart
Stream<DouYinResp> respStream();
```

#### 使用

**Android**: 在项目的android目录中的build.gradle里添加抖音SDK的仓库地址

```groovy
repositories {
    google()
    mavenCentral()
    maven { url 'https://artifact.bytedance.com/repository/AwemeOpenSDK' }
}
```

**iOS**: 在项目的ios目录中的`Podfile`文件中导入抖音SDK

⚠️:需要注释掉`use_frameworks!`,因为抖音SDK有静态引用

```
pod 'DouyinOpenSDK'
```

* `info.plist`的`Queried URL Schemes`添加以下几个值

| douyinopensdk | douyinliteopensdk | douyinsharesdk | snssdk1128 |
|---------------|-------------------|----------------|------------|

* TARGETS->Info->URL Types*中添加URL_Schemes为注册的抖音Client Key,用于处理授权登录后返回自己的App
* 项目的`AppDelegate.swift`添加回调监听
```swift
import UIKit
import Flutter
import DouyinOpenSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, DouyinOpenSDKLogDelegate {
    override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        DouyinOpenSDKApplicationDelegate.sharedInstance().logDelegate = self
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let result = DouyinOpenSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] as? String)
        return result;
    }

    func onLog(_ logInfo: String) {
        NSLog("douyin log %@", logInfo)
    }
}

```
#### Example

```dart
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
    initState = await _douyinPlugin.registerDouyinApp(apiKey: '');
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

```
