import 'package:flutter_test/flutter_test.dart';
import 'package:reactify/composables/watch_effect.dart';
import 'package:reactify/foundation/ref.dart';

void main() {
  group('watchEffect', () {
    test('should track dependencies and react to changes', () async {
      final ref = Ref<int>(0);
      int effectRuns = 0;

      final stop = watchEffect(() {
        effectRuns = ref.value; // Dependency tracking
      });

      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(0));
      ref.value = 1;
      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(1));
      ref.value = 2;
      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(2));

      stop(); // Stop watching
      ref.value = 3;
      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(2)); // Should not change after stop
    });

    test('should execute immediately when created', () async {
      final ref = Ref<int>(42);
      int effectRuns = 0;

      watchEffect(() {
        effectRuns = ref.value;
      });

      await Future.delayed(Duration.zero);

      expect(effectRuns, equals(42));
    });

    test('should stop tracking after dispose', () async {
      final ref = Ref<int>(0);
      int effectRuns = 0;

      final stop = watchEffect(() {
        effectRuns = ref.value;
      });

      ref.value = 10;
      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(10));

      stop();
      ref.value = 20;
      await Future.delayed(Duration.zero);
      expect(effectRuns, equals(10)); // No update after stop
    });
  });
}
