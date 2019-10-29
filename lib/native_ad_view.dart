import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_ads/native_ad_event_delegate.dart';
import 'package:native_ads/native_ad_param.dart';

typedef NativeAdViewCreatedCallback = void Function(
    NativeAdViewController controller);

class NativeAdView extends StatefulWidget {
  const NativeAdView({
    Key key,
    this.onParentViewCreated,
    this.androidParam,
    this.iosParam,
    this.onAdImpression,
    this.onAdLeftApplication,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdLoaded,
    this.onClickHolder
  }) : super(key: key);

  final NativeAdViewCreatedCallback onParentViewCreated;
  final AndroidParam androidParam;
  final IOSParam iosParam;
  final Function() onAdImpression;
  final Function() onAdLeftApplication;
  final Function() onAdClicked;
  final Function(Map<String, dynamic>) onAdFailedToLoad;
  final Function() onAdLoaded;
  final Function() onClickHolder;

  @override
  State<StatefulWidget> createState() => _NativeAdViewState(
        NativeAdEventDelegate(
          onAdImpression: onAdImpression,
          onAdLeftApplication: onAdLeftApplication,
          onAdClicked: onAdClicked,
          onAdFailedToLoad: onAdFailedToLoad,
          onAdLoaded: onAdLoaded,
          onClickHolder: onClickHolder
        ),
      );
}

class _NativeAdViewState extends State<NativeAdView> {
  _NativeAdViewState(this.delegate);

  final NativeAdEventDelegate delegate;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'com.github.sakebook.android/unified_ad_layout',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: widget.androidParam.toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'com.github.sakebook.ios/unified_ad_layout',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: widget.iosParam.toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onParentViewCreated == null) {
      return;
    }
    final NativeAdViewController controller = NativeAdViewController._(id);
    controller._channel.setMethodCallHandler(delegate.handleMethod);
    widget.onParentViewCreated(controller);
  }
}

class NativeAdViewController {
  NativeAdViewController._(int id) : _channel = _createChannel(id);

  final MethodChannel _channel;

  static MethodChannel _createChannel(int id) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return MethodChannel('com.github.sakebook.android/unified_ad_layout_$id');
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return MethodChannel('com.github.sakebook.ios/unified_ad_layout_$id');
    } else {
      return throw MissingPluginException();
    }
  }
}
