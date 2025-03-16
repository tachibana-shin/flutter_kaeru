import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactivity/foundation/ref.dart';
import 'package:reactivity/widget/watch.dart';

void main() {
  group('Watch Widget', () {
    testWidgets('should rebuild when the reactive value changes', (tester) async {
      final ref = Ref<int>(0);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Watch(
            builder: (context) => Text('Value: ${ref.value}'),
          ),
        ),
      );

      await Future.delayed(Duration.zero);
      expect(find.text('Value: 0'), findsOneWidget);

      ref.value = 1;
      await tester.pump();
      await Future.delayed(Duration.zero);
      expect(find.text('Value: 1'), findsOneWidget);
    });

    testWidgets('should not rebuild if the value does not change', (tester) async {
      final ref = Ref<int>(5);
      int buildCount = 0;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Watch(
            builder: (context) {
              buildCount++;
              return Text('Value: ${ref.value}');
            },
          ),
        ),
      );

      await Future.delayed(Duration.zero);
      expect(buildCount, equals(1));
      ref.value = 5; // No change in value
      await Future.delayed(Duration.zero);
      await tester.pump();
      await Future.delayed(Duration.zero);
      expect(buildCount, equals(1)); // Should not rebuild
    });

    testWidgets('should update multiple Watch widgets tracking the same ref', (tester) async {
      final ref = Ref<int>(0);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              Watch(builder: (context) => Text('First: ${ref.value}')),
              Watch(builder: (context) => Text('Second: ${ref.value}')),
            ],
          ),
        ),
      );

      await Future.delayed(Duration.zero);
      expect(find.text('First: 0'), findsOneWidget);
      expect(find.text('Second: 0'), findsOneWidget);

      ref.value = 2;
      await tester.pump();
      await Future.delayed(Duration.zero);

      expect(find.text('First: 2'), findsOneWidget);
      expect(find.text('Second: 2'), findsOneWidget);
    });
  });
}
