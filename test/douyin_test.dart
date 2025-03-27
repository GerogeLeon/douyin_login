import 'dart:async';

import 'package:douyin/douyin.dart';
import 'package:douyin/douyin_method_channel.dart';
import 'package:douyin/douyin_platform_interface.dart';
import 'package:douyin/model/resp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDouyinPlatform
    with MockPlatformInterfaceMixin
    implements DouyinPlatform {
  @override
  Future<String> registerDouyinApp({required String apiKey}) {
    return Future.value("success");
  }

  @override
  Stream<DouYinResp> respStream() {
    return StreamController<DouYinResp>().stream;
  }

  @override
  Future<String> authorLogin({required String scopeKey}) {
    return Future.value("success");
  }
}

void main() {
  final DouyinPlatform initialPlatform = DouyinPlatform.instance;

  test('$MethodChannelDouyin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDouyin>());
  });

  test('getPlatformVersion', () async {
    Douyin douyinPlugin = Douyin();
    MockDouyinPlatform fakePlatform = MockDouyinPlatform();
    DouyinPlatform.instance = fakePlatform;

    expect(await douyinPlugin.registerDouyinApp(apiKey: ''), '42');
  });
}
