import 'dart:io';

import 'package:flutter/foundation.dart';

String getAdBannerUnitId() {
  String bannerUnitId = "";
  if (Platform.isAndroid) {
    // Android のとき
    bannerUnitId = kDebugMode
        ? "ca-app-pub-3940256099942544/6300978111" // Androidのデモ用バナー広告ID
        : "ca-app-pub-3940256099942544/6300978111";
  } else if (Platform.isIOS) {
    // iOSのとき
    bannerUnitId = kDebugMode
        ? "ca-app-pub-3940256099942544/2934735716" // iOSのデモ用バナー広告ID
        : "ca-app-pub-3940256099942544/2934735716";
  }
  return bannerUnitId;
}
