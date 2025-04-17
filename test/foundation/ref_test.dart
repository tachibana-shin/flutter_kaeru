import 'package:flutter_test/flutter_test.dart';
import 'package:kaeru/composables/watch_effect.dart';
import 'package:kaeru/foundation/ref.dart';

void main() {
  group('Ref', () {
    test('should initialize with given value', () {
      final ref = Ref<int>(10);
      expect(ref.value, equals(10));
    });

    test('should update value and notify listeners', () async {
      final ref = Ref<int>(5);
      int notificationCount = 0;

      ref.addListener(() {
        notificationCount++;
      });

      await Future.delayed(Duration.zero);
      expect(notificationCount, equals(0));
      ref.value = 10;
      await Future.delayed(Duration.zero);
      expect(ref.value, equals(10));
      expect(notificationCount, equals(1));
    });

    test('should not notify listeners if value does not change', () async {
      final ref = Ref<int>(3);
      int notificationCount = 0;

      ref.addListener(() {
        notificationCount++;
      });

      ref.value = 3; // Setting the same value
      await Future.delayed(Duration.zero);
      expect(notificationCount, equals(0));
    });

    test('should track dependencies when accessed', () async {
      final ref = Ref<int>(1);
      int effectRuns = 0;

      final stop = watchEffect$(() {
        ref.value;
        effectRuns++;
      });

      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(1));
      ref.value = 2;
      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(2));

      stop();
      ref.value = 3;
      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(2)); // No more tracking after stop
    });
  });
}