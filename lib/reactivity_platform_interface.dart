import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'reactivity_method_channel.dart';

abstract class ReactivityPlatform extends PlatformInterface {
  /// Constructs a ReactivityPlatform.
  ReactivityPlatform() : super(token: _token);

  static final Object _token = Object();

  static ReactivityPlatform _instance = MethodChannelReactivity();

  /// The default instance of [ReactivityPlatform] to use.
  ///
  /// Defaults to [MethodChannelReactivity].
  static ReactivityPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ReactivityPlatform] when
  /// they register themselves.
  static set instance(ReactivityPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
