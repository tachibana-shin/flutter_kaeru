[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/tachibana-shin/flutter_kaeru)

# Kaeru for Flutter

**Kaeru** is a comprehensive and efficient reactivity system for Flutter, inspired by Vue 3's `@vue/reactivity`. It provides a fully functional reactive programming model that makes state management in Flutter simple, optimized, and declarative.

## 🚀 Core Features

- **Fully reactive state management** with `Ref`, `Computed`, `AsyncComputed`, and `watchEffect`.
- **Automatic dependency tracking** for efficient updates.
- **Supports both synchronous and asynchronous computed values**.
- **Optimized UI updates** with `Watch` and `KaeruMixin`.
- **Seamless integration with ChangeNotifier and ValueNotifier.**

> [!TIP]
> If in KaeruMixin you have use `watch$` with `watch` and `watchEffect$` with `watchEffect`

## List composables

- `useContext`
- `useHoverWidget`
- `useRef`
- `useState`
- `useWidgetBounding`
- `useWidgetSize`

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

## New API `KaeruWidget`

The `setup()` method returns a `Widget Function()`, which acts as your `build` method.

```dart
class CounterWidget extends KaeruWidget<CounterWidget> {
  final int depend;
  const CounterWidget({super.key, required this.depend});

  @override
  Setup setup() {
    final count = ref(0);
    final depend = prop((w) => w.depend);

    watchEffect(() {
      count.value; // track
      debugPrint('effect in count changed ${count.value}');
    });
    watchEffect(() {
      depend.value; // track
      debugPrint('effect in depend changed ${depend.value}');
    });

    onMounted(() {
      debugPrint('mounted');
    });

    return () {
      debugPrint('main counter re-build');

      return Row(children: [
        Watch(() {
          debugPrint('depend in counter changed');
          return Text('depend = ${depend.value}');
        }),
        Watch(() {
          debugPrint('counter in counter changed');
          return Text('counter = ${count.value}');
        }),
        IconButton(onPressed: () => count.value++, icon: const Icon(Icons.add)),
        IconButton(
            onPressed: () => count.value--, icon: const Icon(Icons.remove)),
      ]);
    };
  }
}
```

You can even create compositions with this

```dart
Computed<double> useScaleWidth(Ref<double> ref) {
  final ctx = useKaeruContext();
  assert(ctx != null); // Ensure if use composition without KaeruWidget

  final screenWidth = ctx.size.width;
  return computed(() => ref.value / screenWidth);
}
```

- All hooks life and reactivity ready
- `useContext() -> BuildContext`
- `useWidget<T> -> T is Widget`

# Kaeru Hooks & Widgets (Full List)

## 1. Lifecycle / Core Hooks

| Hook / Composable | Description                                       | Notes                          |
| ----------------- | ------------------------------------------------- | ------------------------------ |
| `onBeforeUnmount` | Register a callback to run before widget unmounts | Auto dispose / cleanup         |
| `onUpdated`       | Register a callback when reactive value changes   | Works with `Computed` or `Ref` |
| `useLifeContext`  | Access current Kaeru lifecycle context            | Internal reactive context      |
| `useKaeruContext` | Access current Kaeru reactive context             | Returns current `KaeruMixin`   |
| `onMounted`       | Register a callback after widget is mounted       | Runs once                      |
| `onUnmounted`     | Register a callback after widget is disposed      | Runs once                      |

---

## 2. Reactive / Controller Hooks (New)

| Hook / Composable          | Description                                                       | Notes                                                                                                   |
| -------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| `useTabController`         | Creates a `TabController` with automatic dispose                  | Requires `TickerProvider`                                                                               |
| `useAnimationController`   | Creates an `AnimationController` with automatic dispose           | Needs `vsync`                                                                                           |
| `useScrollController`      | Creates a `ScrollController` with automatic dispose               | For `ListView` / `ScrollView`                                                                           |
| `useTextEditingController` | Creates a `TextEditingController` with automatic dispose          | Can bind reactively                                                                                     |
| `usePageController`        | Creates a `PageController` with automatic dispose                 | For `PageView`                                                                                          |
| `useValueNotifier<T>`      | Creates a `ValueNotifier<T>` with automatic dispose               | Reactive Kaeru binding                                                                                  |
| `useFocusNode`             | Creates a `FocusNode` with automatic dispose                      | For focus management                                                                                    |
| `useTicker`                | Creates a low-level `Ticker` with automatic dispose               | Custom animation without `AnimationController`                                                          |
| `useKeepAliveClient`       | Creates a `KeepAliveClient` with automatic dispose                | Simply calling this hook will make your widget behave as if it were a widget with KeepAliveClientMixin. |
| `useRestoration`           | Creates a `RestorationController` with automatic dispose          | For restoration management                                                                              |
| `useSingleTickerState`     | Creates a `SingleTickerProviderStateMixin` with automatic dispose | For custom animation without `AnimationController`                                                      |

---

## 4. Notes

- **Lifecycle hooks**:
  - `onBeforeUnmount`, `onUpdated`, etc., are core reactive hooks for cleanup & reactive side effects.
- **Controller hooks**:
  - Auto dispose, ready for reactive binding with Kaeru.
- **Widgets with built-in Mixins**:
  - Enable Flutter core behavior without creating State manually.
- **Dynamic delegate pattern**:
  - Combine multiple delegates (Animation, Scroll, Tab, ValueNotifier) with auto setup & dispose.


## ✨ For Large Language Models (LLMs)

This repository includes special files to help you understand and generate code for this library.

- **`llm.txt`**: A concise guide covering the main concepts and providing a quick-start example. Use this for a general overview.
- **`llm_full.txt`**: A comprehensive documentation file containing detailed descriptions of every public class, function, and hook. Use this as a full reference for generating detailed or complex code.

When asked to work with this library, refer to these files to ensure your generated code is accurate and idiomatic.


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

> > > [!TIP]
> > > If in KaeruMixin you have use `watch$` with `watch` and `watchEffect$` with `watchEffect`

By default `Watch` doesn"t care about external changes e.g.

```dart
class ExampleState extends State<Example> {
  int counter = 1;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        counter++;
      });
    });
  }

  @override
  Widget build(context) {
    return Watch(() => Text('counter = $counter')); // every is 'counter = 1'
  }
}
```

so if static dependency is used in `Watch` you need to set it in the `dependencies` option

```dart
class ExampleState extends State<Example> {
  int counter = 1;

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        counter++;
      });
    });
  }

  @override
  Widget build(context) {
    return Watch(dependencies: [counter], () => Text('counter = $counter')); // amazing, now 'counter = 1', 'counter = 2'....
  }
}
```

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

| Parameter  | Type                  | Description                                 |
| ---------- | --------------------- | ------------------------------------------- |
| `ctx`      | `ReactiveNotifier<T>` | The reactive object to select from.         |
| `selector` | `U Function(T value)` | Function to select a value from the object. |

#### Example:

```dart
final map = Ref({'foo': 0, 'bar': 0});

Watch(() {
  // Only recomputes when 'foo' changes
  final foo = usePick(() => map.value['foo']);
  print(foo.value); // 0
});

map.value = {...map.value, 'foo': 1};
```

### 8️⃣ **Cleanup: `onWatcherCleanup`**

Registers a callback to be called when the watcher or computed is refreshed or disposed.

#### Parameters:

| Parameter  | Type           | Description                               |
| ---------- | -------------- | ----------------------------------------- |
| `callback` | `VoidCallback` | Function to be called on cleanup/dispose. |

#### Example:

```dart
watchEffect$(() {
  // ... reactive code ...
  onWatcherCleanup(() {
    // cleanup logic here
  });
});

// or widget Watch

Watch(() {
  onWatcherCleanup(() {
    // cleanup logic here
  });

  ////
});

// or Computed

Computed(() {
  onWatcherCleanup(() {
    // cleanup logic here
  });

  ////
});

```

---

### 9️⃣ **Utility: `nextTick`**

Runs a callback after the current microtask queue is flushed (similar to `Promise.resolve().then()` in JS).

#### Parameters:

| Function | Description |
| --- | --- |
| `ref<T>(value)` | Creates a reactive reference. Access/modify its content via the `.value` property. |
| `computed<T>(fn)` | Creates a read-only, cached value that is derived from other reactive sources. |
| `asyncComputed<T>(fn)` | A version of `computed` for asynchronous operations, returning `null` until the future completes. |
| `watchEffect(fn)` | Runs a function immediately and re-runs it automatically whenever any of its reactive dependencies change. |
| `watch(sources, fn)` | Triggers a callback only when specific `sources` change. |
| `prop<T>(fn)` | Creates a reactive `Computed` property from the parent widget's attributes. |

### 2. Lifecycle Hooks

Manage your widget's side effects with simple lifecycle functions inside `setup()`:

| Hook | Description |
| --- | --- |
| `onMounted(fn)` | Called once after the widget is first inserted into the widget tree. |
| `onUpdated(fn)` | Called after the widget updates. |
| `onBeforeUnmount(fn)` | Called just before the widget is removed from the widget tree. Perfect for cleanup. |
| `onDeactivated(fn)` | Called when the widget is deactivated. |
| `onActivated(fn)` | Called when the widget is re-inserted into the tree after being deactivated. |

### 3. Flutter Hooks

Kaeru provides `use*` hooks that automatically create and dispose of common Flutter objects.

| Hook | Description |
| --- | --- |
| `useAnimationController()` | Creates and disposes of an `AnimationController`. |
| `useTabController()` | Creates and disposes of a `TabController`. |
| `useScrollController()` | Creates and disposes of a `ScrollController`. |
| `useTextEditingController()` | Creates and disposes of a `TextEditingController`. |
| `useFocusNode()` | Creates and disposes of a `FocusNode`. |
| `useSingleTickerState()` | Provides a `TickerProvider` for animations. |
| `useKeepAliveClient()` | Keeps a widget alive in a list (e.g., `ListView`). |
| `useContext()` | Gets the current `BuildContext`. |
| `useWidget<T>()` | Gets the current widget instance. |

---

## 🏗 Contributing

Pull requests and feature requests are welcome! Feel free to open an issue or contribute.

## 📜 License

MIT License. See [LICENSE](LICENSE) for details.
