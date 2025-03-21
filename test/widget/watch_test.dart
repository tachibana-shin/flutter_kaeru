import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kaeru/kaeru.dart';

void main() {
  group('Watch Widget', () {
    // testWidgets('should rebuild when the reactive value changes', (tester) async {
    //   final ref = Ref<int>(0);
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: Watch(
    //         builder: (context) => Text('Value: ${ref.value}'),
    //       ),
    //     ),
    //   );

    //   expect(find.text('Value: 0'), findsOneWidget);

    //   ref.value = 1;
    //   await Future.delayed(Duration.zero);
    //   // Wait for microtasks scheduled by oneCallTask to complete.
    //   await tester.pumpAndSettle();
    //   expect(find.text('Value: 1'), findsOneWidget);
    // });

    testWidgets('should not rebuild if the value does not change',
        (tester) async {
      final ref = Ref<int>(5);
      int buildCount = 0;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Watch(() {
            buildCount++;
            return Text('Value: ${ref.value}');
          }),
        ),
      );

      expect(buildCount, equals(1));
      ref.value = 5; // No change in value
      await tester.pump();
      expect(buildCount, equals(1)); // Should not rebuild
    });

    // testWidgets('should update multiple Watch widgets tracking the same ref', (tester) async {
    //   final ref = Ref<int>(0);
    //   await tester.pumpWidget(
    //     Directionality(
    //       textDirection: TextDirection.ltr,
    //       child: Column(
    //         children: [
    //           Watch(builder: () => Text('First: ${ref.value}')),
    //           Watch(builder: () => Text('Second: ${ref.value}')),
    //         ],
    //       ),
    //     ),
    //   );

    //   expect(find.text('First: 0'), findsOneWidget);
    //   expect(find.text('Second: 0'), findsOneWidget);

    //   ref.value = 2;
    //   await tester.pump();

    //   expect(find.text('First: 2'), findsOneWidget);
    //   expect(find.text('Second: 2'), findsOneWidget);
    // });
  });
}
