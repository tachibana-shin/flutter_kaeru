import 'package:flutter/material.dart';
import 'package:kaeru/kaeru.dart';

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
            appBar: AppBar(title: const Text("Kaeru Example")),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  TextButton(
                      child: Text('refresh'), onPressed: () => setState(() {})),
                  counterDefine((onMax: () => print('OK'))),
                ]))));
  }
}

class App2 extends StatelessWidget {
  final showCounter = Ref(true);

  App2({super.key});

  @override
  Widget build(context) {
    return Watch(() => Row(children: [
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

class _CounterState extends State<Counter> with KaeruMixin, KaeruLifeMixin {
  late final foo = ref<int>(0);
  late final fooDouble = computed(() => foo.value * 2);
  late final fooDoublePlus = Computed<int>(() => foo.value + 1);
  late final fooGtTeen = computed<bool>(() {
    print('Computed call');
    return fooDouble.value > 10;
  });
  late final computedOnlyListen = computed(() => foo.value);
  final bar = Ref<int>(0);

  @override
  void initState() {
    watchEffect(() {
      print('watchEffect run');

      if (fooDoublePlus.value % 2 == 0) return;
      print('foo + bar = ${foo.value + bar.value}');
    });

    watch([computedOnlyListen], () {
      print('computed only listen changed');
    });

    onMounted(() => print('✅ Widget Mounted!'));
    onDependenciesChanged(() => print('🔄 Dependencies Changed!'));
    onUpdated(() => print('♻️ Widget Updated!'));
    onDeactivated(() => print('⚠️ Widget Deactivated!'));
    onBeforeUnmount(() => print('🗑 Widget Disposed!'));

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
        Watch(() {
          print('Watch render');
          if (fooGtTeen.value) {
            return Watch(() {
              print('Watch child 1 render');

              return Text("Bar: ${bar.value}");
            });
          } else {
            return Text("Bar: ${bar.value}");
          }
        }),
        Watch(() {
          print('Widget parent ShowFoo render');
          return bar.value % 2 == 0 ? SizedBox.shrink() : ShowFoo(foo: foo);
        })
      ],
    );
  }
}

class ShowFoo extends StatefulWidget {
  final Ref<int> foo;

  const ShowFoo({super.key, required this.foo});

  @override
  createState() => _ShowFooState();
}

class _ShowFooState extends State<ShowFoo> with KaeruListenMixin, KaeruMixin {
  late final _fooDouble = computed(() {
    print('ShowFoo computed emit change');
    return widget.foo.value * 2;
  });
  @override
  void initState() {
    listen(widget.foo, () {
      print('ShowFoo emit change foo ${widget.foo.value}');
    });

    super.initState();
  }

  @override
  Widget build(context) {
    return Column(children: [
      Watch(() => Text('ShowFoo: ${widget.foo.value}')),
      Watch(() => Text('foo * 2 = ${_fooDouble.value}'))
    ]);
  }
}

///////////////////////////// test usePick

class TestUsePick extends StatefulWidget {
  @override
  createState() => _TestUsePickState();
}

class _TestUsePickState extends State<TestUsePick> with KaeruMixin {
  late final map = ref({'counter': 0, 'bar': 0});

  @override
  Widget build(context) {
    return ListView(
      children: [
        Row(children: [
          Watch(() {
            final counter = usePick(map, (value) => value['counter']);
            print('renfd');
            return Text('counter = ${counter.value}');
          }),
          Watch(() {
            print('renfd bar');
            return Text('bar = ${map.value['bar']}');
          })
        ]),
        TextButton(
          onPressed: () =>
              map.value = {...map.value, 'counter': map.value['counter']! + 1},
          child: Text('counter++'),
        ),
        TextButton(
          onPressed: () =>
              map.value = {...map.value, 'bar': map.value['bar']! + 1},
          child: Text('bar++'),
        )
      ],
    );
  }
}

//============================= test define_widget //

typedef FooProps = ({Ref<int> counter});
// ignore: non_constant_identifier_names
final Foo = defineWidget((FooProps props) {
  final foo = $ref(0);

  void onPressed() {
    foo.value++;
  }

  void resetParent() {
    props.counter.value = 0;
  }

  return (ctx) => Row(
        children: [
          TextButton(
              onPressed: onPressed,
              child:
                  Text('counter + foo = ${props.counter.value + foo.value}')),
          TextButton(
              onPressed: resetParent, child: Text('Reset counter parent'))
        ],
      );
});

typedef CounterProps = ({VoidCallback onMax});
final counterDefine = defineWidget((CounterProps props) {
  final counter = $ref(0);
  final (isHover: isHover, hoverWrap: hoverWrap) = useHoverWidget();

  print('Render once');

  void onPressed() {
    counter.value++;

    if (counter.value > 10) props.onMax();
  }

  return (ctx) => Row(
        children: [
          TextButton(
              onPressed: onPressed, child: Text('counter = $counter.value')),
          Text('Foo is hoving: ${isHover.value}',
              style: TextStyle(color: Colors.red)),
          hoverWrap((_) => Foo((counter: counter)))
        ],
      );
});
