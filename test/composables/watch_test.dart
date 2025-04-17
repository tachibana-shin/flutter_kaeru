import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaeru/composables/watch.dart';

void main() {
  group('watch', () {
    test('should trigger callback when source changes', () async {
      final notifier = ValueNotifier<int>(0);
      int callbackCount = 0;

      final stopWatching = watch$([notifier], () {
        callbackCount++;
      });

      await Future.delayed(Duration.zero);
      expect(callbackCount, equals(0));
      
      notifier.value = 1;
      await Future.delayed(Duration.zero);
      expect(callbackCount, equals(1));
      
      notifier.value = 2;
      await Future.delayed(Duration.zero);
      expect(callbackCount, equals(2));
      
      stopWatching();
      notifier.value = 3;
      await Future.delayed(Duration.zero);
      expect(callbackCount, equals(2)); // Should not trigger after stopping
    });

    test('should trigger callback immediately if immediate is true', () async {
      final notifier = ValueNotifier<int>(0);
      int callbackCount = 0;

      watch$([notifier], () {
        callbackCount++;
      }, immediate: true);

      await Future.delayed(Duration.zero);
      expect(callbackCount, equals(1)); // Should be called immediately
    });

    test('should not trigger callback if no source changes', () async {
      final notifier = ValueNotifier<int>(0);
      int callbackCount = 0;

      watch$([notifier], () {
        callbackCount++;
      });

      await Future.delayed(Duration.zero);
      expect(callbackCount, equals(0));
    });
  });
}
