import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'reactivity_platform_interface.dart';

/// An implementation of [ReactivityPlatform] that uses method channels.
class MethodChannelReactivity extends ReactivityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('reactivity');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
