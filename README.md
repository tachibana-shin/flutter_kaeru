# Kaeru for Flutter

**Kaeru** is a comprehensive and efficient reactivity system for Flutter, inspired by Vue 3's `@vue/reactivity`. It provides a fully functional reactive programming model that makes state management in Flutter simple, optimized, and declarative.

## 🚀 Features

- **Fully reactive state management** with `Ref`, `Computed`, `AsyncComputed`, and `watchEffect`.
- **Automatic dependency tracking** for efficient updates.
- **Supports both synchronous and asynchronous computed values**.
- **Optimized UI updates** with `Watch` and `KaeruMixin`.
- **Seamless integration with ChangeNotifier and ValueNotifier.**

> [!TIP]
> If in KaeruMixin you have use `watch$` with `watch` and `watchEffect$` with `watchEffect`

---

## 📦 Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  kaeru:
    git:
      url: https://github.com/tachibana-shin/flutter_kaeru.git
```

Import it in your project:

```dart
import 'package:kaeru/kaeru.dart';
```

---

## 🏗 API Documentation

### 1️⃣ **Reactive State: `Ref<T>`**

Represents a reactive variable that automatically triggers updates when changed.

#### Parameters:

| Parameter | Type | Description                                  |
| --------- | ---- | -------------------------------------------- |
| `value`   | `T`  | The initial value of the reactive reference. |

#### Methods:

| Method                           | Returns       | Description                                          |
| -------------------------------- | ------------- | ---------------------------------------------------- |
| `select<U>(U Function(T value))` | `Computed<U>` | Creates a computed value derived from this `Ref<T>`. |

#### Example:

```dart
final count = Ref(0);
count.addListener(() {
  print("Count changed: ${count.value}");
});

count.value++;  // ✅ Triggers update

final doubleCount = count.select((v) => v * 2);
print(doubleCount.value); // ✅ 0
count.value = 5;
print(doubleCount.value); // ✅ 10
```

### 2️⃣ **Derived State: `Computed<T>`**

Creates a computed value that automatically updates when dependencies change.

#### Parameters:

| Parameter | Type           | Description                                 |
| --------- | -------------- | ------------------------------------------- |
| `getter`  | `T Function()` | A function that returns the computed value. |

#### Methods:

| Method                           | Returns       | Description                       |
| -------------------------------- | ------------- | --------------------------------- |
| `select<U>(U Function(T value))` | `Computed<U>` | Creates a derived computed value. |

#### Example:

```dart
final count = Ref(2);
final doubleCount = Computed(() => count.value * 2);

print(doubleCount.value); // ✅ 4
count.value++;
print(doubleCount.value); // ✅ 6

final tripleCount = doubleCount.select((v) => v * 1.5);
print(tripleCount.value); // ✅ 9
```

### 3️⃣ **Effects: `watchEffect` & `watch`**

#### `watchEffect(Function callback) -> VoidCallback`

- Automatically tracks dependencies and re-executes when values change.

#### Example:

```dart
final stop = watchEffect$(() {
  print("Count is now: ${count.value}");
});

count.value++;  // ✅ Automatically tracks dependencies
stop(); // ✅ Stops watching
```

#### `watch$(List<ChangeNotifier> sources, Function callback, {bool immediate = false}) -> VoidCallback`

- Watches multiple `ChangeNotifier` sources.
- If `immediate = true`, executes the callback immediately.

#### Example:

```dart
final stop = watch$([count], () {
  print("Count changed: ${count.value}");
}, immediate: true);

stop(); // ✅ Stops watching
```

### 4️⃣ **Asynchronous Derived State: `AsyncComputed<T>`**

Handles computed values that depend on asynchronous operations.

#### Parameters:

| Parameter            | Type                       | Description                                             |
| -------------------- | -------------------------- | ------------------------------------------------------- |
| `getter`             | `Future<T> Function()`     | A function returning a future value.                    |
| `defaultValue`       | `T?`                       | An optional initial value before computation completes. |
| `beforeUpdate`       | `T? Function()`            | An optional function to run before updating the value.  |
| `notifyBeforeUpdate` | `bool = true`              | Whether to notify listeners before updating the value.  |
| `onError`            | `Function(dynamic error)?` | An optional error handler.                              |
| `immediate`          | `bool`                     | Whether to compute immediately.                         |

#### Example:

```dart
final asyncData = AsyncComputed(() async {
  await Future.delayed(Duration(seconds: 1));
  return "Loaded";
}, defaultValue: "Loading", onError: (e) => print("Error: $e"), immediate: true);

print(asyncData.value);  // ✅ "Loading"
await Future.delayed(Duration(seconds: 1));
print(asyncData.value);  // ✅ "Loaded"
```

### 5️⃣ **UI Integration: `KaeruMixin` and `Watch`**

#### `KaeruMixin` (StatefulWidget Integration)

Allows stateful widgets to easily integrate with reactive values.

#### Example:

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with KaeruMixin {
  late final Ref<int> count;

  @override
  void initState() {
    super.initState();
    count = ref(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Watch(() => Text("Count: ${count.value}")),
        ElevatedButton(
          onPressed: () => count.value++,
          child: Text("Increment"),
        ),
      ],
    );
  }
}
```

#### `Watch` (Automatic UI Rebuilds)

A widget that automatically updates when its dependencies change.

#### Example:

```dart
Watch(
  () => Text("Value: ${count.value}"),
)
```

### `KaeruBuilder` (Builder for Kaeru)

### Example:
```dart
KaeruBuilder((context) {
  final counter = context.ref(0);

  return Watch(() => Text(counter.value.toString()));
});
```

### 6️⃣ **Integration with ValueNotifier & ChangeNotifier**

#### `ValueNotifier.toRef()`

Converts a `ValueNotifier<T>` into a `Ref<T>`.

#### Example:

```dart
final valueNotifier = ValueNotifier(0);
final ref = valueNotifier.toRef();

ref.addListener(() {
  print("Updated: ${ref.value}");
});

valueNotifier.value = 10;  // ✅ Ref updates automatically
```

#### `ValueNotifier` Extension

Adds `.toRef()` to `ValueNotifier` to integrate seamlessly.

### 7️⃣ **Selector: `usePick`**

Creates a computed value that tracks only the selected part of a reactive object, optimizing updates.

#### Parameters:

| Parameter   | Type                         | Description                                      |
| ----------- | ---------------------------- | ------------------------------------------------ |
| `ctx`       | `ReactiveNotifier<T>`        | The reactive object to select from.              |
| `selector`  | `U Function(T value)`        | Function to select a value from the object.      |

#### Example:

```dart
final map = Ref({'foo': 0, 'bar': 0});

Watch(() {
  // Only recomputes when 'foo' changes
  final foo = usePick(map, (value) => value['foo']);
  print(foo.value); // 0
});

map.value = {...map.value, 'foo': 1};
```

---

### 📌 Kaeru Lifecycle & Listening Mixins

**KaeruLifeMixin** and **KaeruListenMixin** are powerful mixins designed to simplify Flutter development by providing Vue-like lifecycle hooks and reactive state listening.

### 🎯 Why Use These Mixins?

✅ Cleaner code: No need to override multiple lifecycle methods or manage listeners manually.
✅ Reusable: Apply them to any StatefulWidget to enhance reactivity.
✅ Inspired by Vue: Provides a familiar development experience for reactive state management.

### 🟢 KaeruLifeMixin

**KaeruLifeMixin** provides Vue-like lifecycle hooks for `StatefulWidget`. It enables multiple callbacks for different lifecycle events.

#### 🚀 Features

- `onMounted()`: Called when the widget is first created (`initState`).
- `onDependenciesChanged()`: Called when dependencies change (`didChangeDependencies`).
- `onUpdated()`: Called when the widget receives updated properties (`didUpdateWidget`).
- `onDeactivated()`: Called when the widget is temporarily removed (`deactivate`).
- `onBeforeUnmount()`: Called just before the widget is disposed (`dispose`).

#### 📝 Example Usage

```dart
class MyComponent extends StatefulWidget {
  @override
  _MyComponentState createState() => _MyComponentState();
}

class _MyComponentState extends State<MyComponent> with KaeruLifeMixin<MyComponent> {
  @override
  void initState() {
    super.initState();

    onMounted(() => print('✅ Widget Mounted!'));
    onDependenciesChanged(() => print('🔄 Dependencies Changed!'));
    onUpdated(() => print('♻️ Widget Updated!'));
    onDeactivated(() => print('⚠️ Widget Deactivated!'));
    onBeforeUnmount(() => print('🗑 Widget Disposed!'));
  }

  @override
  Widget build(BuildContext context) {
    return Text('KaeruLifeMixin Example');
  }
}
```

### 🟢 KaeruListenMixin

**KaeruListenMixin** simplifies listening to `ChangeNotifier` updates within a `StatefulWidget`. It allows adding listeners dynamically and managing their cleanup automatically.

#### 🚀 Features

- `listen()`: Subscribes to a single `ChangeNotifier` and executes a callback when it changes.
- `listenAll()`: Subscribes to multiple `ChangeNotifiers` with a single callback.
- Returns a cancel function to remove listeners when necessary.

#### 📝 Example Usage

##### Listening to a Single Notifier

```dart
class MyNotifier extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

class MyComponent extends StatefulWidget {
  @override
  _MyComponentState createState() => _MyComponentState();
}

class _MyComponentState extends State<MyComponent> with KaeruListenMixin<MyComponent> {
  final myNotifier = MyNotifier();
  VoidCallback? cancelListener;

  @override
  void initState() {
    super.initState();

    cancelListener = listen(myNotifier, () {
      print('Single notifier changed!');
    });
  }

  @override
  void dispose() {
    cancelListener?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Listening to a single ChangeNotifier');
  }
}
```

##### Listening to Multiple Notifiers

```dart
class NotifierA extends ChangeNotifier {
  void update() => notifyListeners();
}

class NotifierB extends ChangeNotifier {
  void update() => notifyListeners();
}

class MyComponent extends StatefulWidget {
  @override
  _MyComponentState createState() => _MyComponentState();
}

class _MyComponentState extends State<MyComponent> with KaeruListenMixin<MyComponent> {
  final notifierA = NotifierA();
  final notifierB = NotifierB();
  VoidCallback? cancelListeners;

  @override
  void initState() {
    super.initState();

    cancelListeners = listenAll([notifierA, notifierB], () {
      print('One of the notifiers changed!');
    });
  }

  @override
  void dispose() {
    cancelListeners?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Listening to multiple ChangeNotifiers');
  }
}
```

### ✨ Summary

| Feature            | KaeruLifeMixin                                                | KaeruListenMixin                                 |
| ------------------ | ------------------------------------------------------------- | ------------------------------------------------ |
| Lifecycle Hooks    | ✅ Provides `onMounted`, `onUpdated`, `onBeforeUnmount`, etc. | ❌ Not applicable                                |
| Reactive Listeners | ❌ Not applicable                                             | ✅ Handles `ChangeNotifier` updates              |
| Automatic Cleanup  | ✅ Hooks are executed at proper lifecycle stages              | ✅ Listeners are removed automatically           |
| Code Simplicity    | ✅ Reduces the need for overriding multiple lifecycle methods | ✅ Manages `ChangeNotifier` subscriptions easily |

🚀 **KaeruLifeMixin** is perfect for handling widget lifecycle events.
🔄 **KaeruListenMixin** makes managing `ChangeNotifier` listeners easy.

---

## 🎯 API Summary

| Feature                 | Supported |
| ----------------------- | --------- |
| `Ref<T>`                | ✅        |
| `Computed<T>`           | ✅        |
| `AsyncComputed<T>`      | ✅        |
| `watchEffect`           | ✅        |
| `watch`                 | ✅        |
| `KaeruMixin`            | ✅        |
| `Watch` Widget          | ✅        |
| `ValueNotifier.toRef()` | ✅        |
| `ReactiveNotifier<T>`   | ✅        |

This package provides an intuitive and efficient reactivity system for Flutter, making state management much easier and more performant. 🚀

## Example
`example/lib/main.dart`
```dart
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
            body: Padding(padding: const EdgeInsets.all(16.0), child: App2())));
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

    watch$([computedOnlyListen], () {
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
```

## 🛠 Contributing

Pull requests and feature requests are welcome! Feel free to open an issue or contribute.

## 📜 License

MIT License. See [LICENSE](LICENSE) for details.
