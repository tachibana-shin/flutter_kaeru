import 'package:flutter_test/flutter_test.dart';
import 'package:reactivity/reactivity.dart';
import 'package:reactivity/reactivity_platform_interface.dart';
import 'package:reactivity/reactivity_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockReactivityPlatform
    with MockPlatformInterfaceMixin
    implements ReactivityPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ReactivityPlatform initialPlatform = ReactivityPlatform.instance;

  test('$MethodChannelReactivity is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelReactivity>());
  });

  test('getPlatformVersion', () async {
    Reactivity reactivityPlugin = Reactivity();
    MockReactivityPlatform fakePlatform = MockReactivityPlatform();
    ReactivityPlatform.instance = fakePlatform;

    expect(await reactivityPlugin.getPlatformVersion(), '42');
  });
}
