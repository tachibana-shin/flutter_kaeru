import 'package:flutter_test/flutter_test.dart';
import 'package:kaeru/composables/watch_effect.dart';
import 'package:kaeru/foundation/computed.dart';
import 'package:kaeru/foundation/ref.dart';

void main() {
  group('Computed', () {
    test('should compute value lazily and update when dependencies change', () async {
      final count = Ref<int>(2);
      final computedValue = Computed(() => count.value * 2);

      await Future.delayed(Duration.zero);
      expect(computedValue.value, equals(4));
      count.value = 3;
      await Future.delayed(Duration.zero);
      expect(computedValue.value, equals(6));
    });

    test('should not recompute value if dependencies do not change', () async {
      final count = Ref<int>(5);
      int computeRuns = 0;
      final computedValue = Computed(() {
        computeRuns++;
        return count.value * 2;
      });

      await Future.delayed(Duration.zero);
      expect(computeRuns, equals(0));
      await Future.delayed(Duration.zero);
      expect(computedValue.value, equals(10));
      expect(computeRuns, equals(1));

      computedValue.value;
      await Future.delayed(Duration.zero);
      expect(computeRuns, equals(1)); // Should not recompute
    });

    test('should register as a dependency and trigger recomputation when watched', () async {
      final count = Ref<int>(1);
      final computedValue = Computed(() => count.value + 1);

      int effectRuns = 0;
      final stop = watchEffect$(() {
        computedValue.value;
        effectRuns++;
      });

      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(1));
      count.value = 2;
      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(2));

      stop();
      count.value = 3;
      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(2)); // Should not trigger after stop
    });
  });
}
