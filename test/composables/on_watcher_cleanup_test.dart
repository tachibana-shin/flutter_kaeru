import 'package:flutter_test/flutter_test.dart';
import 'package:kaeru/kaeru.dart';

void main() {
  group('onWatcherCleanup', () {
    test('should only use in watcher', () {
      try {
        final counter = Ref(0);
        usePick(() => counter.value);
        fail('should throw error');
      } catch (e) {
        expect(e, isA<NoWatcherFoundException>());
      }
    });

    test('should work on watchEffect', () async {
      final counter = Ref(0);

      int cleanup = 0;
      watchEffect$(() {
        counter.value;

        onWatcherCleanup(() => cleanup++);
      });

      await nextTick();

      expect(cleanup, equals(0));

      for (int i = 0; i < 10; i++) {
        counter.value++;

        await nextTick();

        expect(cleanup, equals(i + 1));
      }
    });

    test('should work on Computed', () async {
      final counter = Ref(0);

      int cleanup = 0;
      Computed(() {
        counter.value;

        onWatcherCleanup(() => cleanup++);
      }).value;

      await nextTick();

      expect(cleanup, equals(0));

      for (int i = 0; i < 10; i++) {
        counter.value++;

        await nextTick();

        expect(cleanup, equals(i + 1));
      }
    });

    test('should work on Computed dispose', () async {
      final counter = Ref(0);

      int cleanup = 0;
      final computed = Computed(() {
        counter.value;

        onWatcherCleanup(() => cleanup++);
      })
        ..value;

      await nextTick();

      expect(cleanup, equals(0));

      counter.value++;

      await nextTick();

      expect(cleanup, equals(1));

      computed.dispose();

      expect(cleanup, equals(2));
    });

    test('should work on watch', () async {
      final notifier = Ref<int>(0);
      int callbackCount = 0;

      final stopWatching = watch$([notifier], () {
        onWatcherCleanup(() => callbackCount++);
      });

      notifier.value++;

      await nextTick();
      expect(callbackCount, equals(0));

      notifier.value++;
      await Future.delayed(Duration.zero);
      expect(callbackCount, equals(1));

      stopWatching();

      await nextTick();

      expect(callbackCount, equals(2));
    });
  });
}
