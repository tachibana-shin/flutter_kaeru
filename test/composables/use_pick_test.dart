import 'package:flutter_test/flutter_test.dart';
import 'package:kaeru/event_bus.dart';
import 'package:kaeru/kaeru.dart';

void main() {
  group('usePick', () {
    test('should not emit when no changes', () async {
      final map = Ref({'foo': 0, 'bar': 0});

      int fooChanges = 0;
      watchEffect$(() {
        final foo = usePick(map, (value) => value['foo']);

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
        final foo = usePick(map, (value) => value['foo']);

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
        final foo = usePick(map, (value) => value['foo']);
        final bar = usePick(map, (value) => value['bar']);

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
  });
}
