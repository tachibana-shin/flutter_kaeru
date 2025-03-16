import 'package:flutter/material.dart';
import 'package:reactivity/reactivity.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text("Reactivity Example")),
            body: Padding(padding: const EdgeInsets.all(16.0), child: App2())));
  }
}

class App2 extends StatelessWidget {
  final showCounter = Ref(true);

  @override
  Widget build(context) {
    return Watch(
        builder: (context) => Row(children: [
              ElevatedButton(
                onPressed: () {
                  showCounter.value = !showCounter.value;
                },
                child: Text(showCounter.value ? 'hide' : 'show'),
              ),
              if (showCounter.value) Counter()
            ]));
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> with ReactivityMixin {
  late final foo = ref<int>(0);
  late final fooDouble = computed(() => foo.value * 2);
  late final fooDoublePlus = Computed<int>(() => foo.value + 1);
  late final fooGtTeen = computed<bool>(() {
    print('Computed call');
    return fooDouble.value > 10;
  });
  final bar = Ref<int>(0);

  @override
  void initState() {
    watchEffect(() {
      print('watchEffect run');

      if (fooDoublePlus.value % 2 == 0) return;
      print('foo + bar = ${foo.value + bar.value}');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Root render');

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            foo.value++;
          },
          child: const Text("Increase foo"),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            bar.value++;
          },
          child: const Text("Increase bar"),
        ),
        const SizedBox(height: 16),
        Watch(builder: (context) {
          print('Watch render');
          if (fooGtTeen.value) {
            return Watch(builder: (c) {
              print('Watch child 1 render');

              return Text("Bar: ${bar.value}");
            });
          } else {
            return Text("Bar: ${bar.value}");
          }
        }),
      ],
    );
  }
}
