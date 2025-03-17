import 'package:flutter_test/flutter_test.dart';
import 'package:kaeru/foundation/async_computed.dart';

void main() {
  group('AsyncComputed', () {
    test('should initialize with default value and update after async computation', () async {
      final asyncComputed = AsyncComputed<int>(
        () async {
          await Future.delayed(Duration(milliseconds: 100));
          return 42;
        },
        defaultValue: 0,
        immediate: true,
      );

      expect(asyncComputed.value, equals(0));
      await Future.delayed(Duration(milliseconds: 150));
      expect(asyncComputed.value, equals(42));
    });

    test('should trigger onError callback when computation fails', () async {
      dynamic errorCaught;
      AsyncComputed<int>(
        () async {
          await Future.delayed(Duration(milliseconds: 100));
          throw Exception('Computation failed');
        },
        onError: (error) {
          errorCaught = error;
        },
        immediate: true,
      );

      await Future.delayed(Duration(milliseconds: 150));
      expect(errorCaught, isNotNull);
      expect(errorCaught.toString(), contains('Computation failed'));
    });

    test('should only update value if latest computation completes', () async {
      int callCount = 0;
      final asyncComputed = AsyncComputed<int>(
        () async {
          callCount++;
          await Future.delayed(Duration(milliseconds: 200));
          return callCount;
        },
        immediate: true,
      );

      expect(asyncComputed.value, isNull);
      await Future.delayed(Duration(milliseconds: 100));
      asyncComputed.dispose(); // Cancelling previous computation
      expect(asyncComputed.value, isNull);
    });

    test('should call beforeUpdate and notify listeners if notifyBeforeUpdate is true', () async {
      int beforeUpdateCallCount = 0;
      final asyncComputed = AsyncComputed<int>(
        () async {
          await Future.delayed(Duration(milliseconds: 100));
          return 100;
        },
        defaultValue: 0,
        beforeUpdate: () {
          beforeUpdateCallCount++;
          return 50;
        },
        notifyBeforeUpdate: true,
        immediate: true,
      );

      await Future.delayed(Duration.zero);
      expect(asyncComputed.value, equals(50));
      await Future.delayed(Duration(milliseconds: 150));
      expect(asyncComputed.value, equals(100));
      await Future.delayed(Duration.zero);
      expect(beforeUpdateCallCount, equals(1));
    });
  });
}
