import 'package:flutter/services.dart';

class NativeAdEventDelegate {
  const NativeAdEventDelegate({
    this.onAdImpression,
    this.onAdLeftApplication,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdLoaded,
    this.onClickHolder
  });

  final Function() onAdImpression;
  final Function() onAdLeftApplication;
  final Function() onAdClicked;
  final Function(Map<String, dynamic>) onAdFailedToLoad;
  final Function() onAdLoaded;
  final Function() onClickHolder;

  Future<dynamic> handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onAdImpression':
      case 'nativeAdDidRecordImpression':
        onAdImpression();
        break;
      case 'onAdLeftApplication':
      case 'nativeAdWillLeaveApplication':
        onAdLeftApplication();
        break;
      case 'onAdClicked':
      case 'nativeAdDidRecordClick':
        onAdClicked();
        break;
      case 'onAdFailedToLoad':
      case 'didFailToReceiveAdWithError':
        onAdFailedToLoad(Map<String, dynamic>.from(call.arguments));
        break;
      case 'onAdLoaded':
      case 'didReceive':
        onAdLoaded();
        break;
      case 'onClickHolder':
        onClickHolder();
        break;
    }
  }
}
