import 'package:flutter_test/flutter_test.dart';
import 'package:kaeru/event_bus.dart';
import 'package:kaeru/kaeru.dart';

void main() {
  group('usePick', () {
    test('should only use in watcher', () {
      try {
        final counter = Ref(0);

        usePick(() => counter.value);
        fail('should throw error');
      } catch (e) {
        expect(e, isA<NoWatcherFoundException>());
      }
    });

    test('should not emit when no changes', () async {
      final map = Ref({'foo': 0, 'bar': 0});

      int fooChanges = 0;
      watchEffect$(() {
        final foo = usePick(() => map.value['foo']);

        foo.value;
        fooChanges++;
      });

      await Future.delayed(Duration.zero);
      expect(fooChanges, equals(1));

      map.value = {
        ...map.value,
        'foo': map.value['foo']! + 1,
      };
      await Future.delayed(Duration.zero);

      expect(fooChanges, equals(2));

      map.value = {
        ...map.value,
        'bar': map.value['bar']! + 1,
      };
      await Future.delayed(Duration.zero);

      expect(fooChanges, equals(2));
    });

    test('should usePick create one computed in lifecycle', () async {
      final map = Ref({'foo': 0, 'bar': 0});

      int countComputes = 0;
      watchEffect$(() {
        final foo = usePick(() => map.value['foo']);

        foo.value;

        final watcher = getCurrentWatcher()!;
        countComputes = watcher.computes.length;
      });

      await Future.delayed(Duration.zero);

      expect(countComputes, equals(1));

      for (int i = 0; i < 10; i++) {
        map.value = {
          ...map.value,
          'foo': map.value['foo']! + 1,
        };

        await Future.delayed(Duration.zero);

        expect(countComputes, equals(1));
      }
    });

    test('should usePick create one computed in lifecycle with multiple keys',
        () async {
      final map = Ref({'foo': 0, 'bar': 0});

      int countComputes = 0;
      watchEffect$(() {
        final foo = usePick(() => map.value['foo']);
        final bar = usePick(() => map.value['bar']);

        foo.value;
        bar.value;

        final watcher = getCurrentWatcher()!;
        countComputes = watcher.computes.length;
      });

      await Future.delayed(Duration.zero);

      expect(countComputes, equals(2));

      for (int i = 0; i < 10; i++) {
        map.value = {
          ...map.value,
          'foo': map.value['foo']! + 1,
        };

        await Future.delayed(Duration.zero);

        expect(countComputes, equals(2));
      }
    });

    test('should usePick clear compute not used', () async {
      final map = Ref({'foo': 0, 'bar': 0});

      int countComputes = 0;
      watchEffect$(() {
        final foo = usePick(() => map.value['foo']);

        foo.value;

        if (foo.value! <= 2) {
          final bar = usePick(() => map.value['bar']);
          bar.value;
        }

        final watcher = getCurrentWatcher()!;
        countComputes = watcher.computes.length;
      });

      await Future.delayed(Duration.zero);

      expect(countComputes, equals(2));

      map.value = {
        ...map.value,
        'foo': map.value['foo']! + 1,
      };

      await Future.delayed(Duration.zero);

      expect(countComputes, equals(2));

      map.value = {
        ...map.value,
        'foo': map.value['foo']! + 1,
      };

      await Future.delayed(Duration.zero);

      expect(countComputes, equals(2));

      map.value = {
        ...map.value,
        'foo': map.value['foo']! + 1,
      };

      await Future.delayed(Duration.zero);

      map.value = {
        ...map.value,
        'foo': map.value['foo']! + 1,
      };

      await Future.delayed(Duration.zero);

      expect(countComputes, equals(1));
    });

    test('should watcher not update if picker not get value', () async {
      final map = Ref({'foo': 0, 'bar': 0});

      int countCall = 0;
      int depends = 0;
      watchEffect$(() {
        usePick(() => map.value['foo']);

        // ignore: invalid_use_of_protected_member
        depends = getCurrentWatcher()!.watchers.length;
        countCall++;
      });

      await Future.delayed(Duration.zero);

      expect(countCall, equals(1));
      expect(depends, equals(0));

      for (int i = 0; i < 10; i++) {
        map.value = {
          ...map.value,
          'foo': map.value['foo']! + 1,
        };

        await Future.delayed(Duration.zero);

        expect(countCall, equals(1));
        expect(depends, equals(0));
      }
    });

    test('should watcher update if picker get value', () async {
      final map = Ref({'foo': 0, 'bar': 0});

      int countCall = 0;
      int depends = 0;
      watchEffect$(() {
        usePick(() => map.value['foo']).value;

        // ignore: invalid_use_of_protected_member
        depends = getCurrentWatcher()!.watchers.length;
        countCall++;
      });

      await Future.delayed(Duration.zero);

      expect(countCall, equals(1));
      expect(depends, equals(1));

      for (int i = 0; i < 10; i++) {
        map.value = {
          ...map.value,
          'foo': map.value['foo']! + 1,
        };

        await Future.delayed(Duration.zero);

        expect(countCall, equals(i + 2));
        expect(depends, equals(1));
      }
    });
  });
}
