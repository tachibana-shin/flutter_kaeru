# Kaeru for Flutter

**Kaeru** is a comprehensive and efficient reactivity system for Flutter, inspired by Vue 3's `@vue/reactivity`. It provides a fully functional reactive programming model that makes state management in Flutter simple, optimized, and declarative.

## 🚀 Features

- **Fully reactive state management** with `Ref`, `Computed`, `AsyncComputed`, and `watchEffect`.
- **Automatic dependency tracking** for efficient updates.
- **Supports both synchronous and asynchronous computed values**.
- **Optimized UI updates** with `Watch` and `KaeruMixin`.
- **Seamless integration with ChangeNotifier and ValueNotifier.**

---

## 📦 Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  kaeru:
    git:
      url: https://github.com/tachibana-shin/flutter-kaeru.git
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
final stop = watchEffect(() {
  print("Count is now: ${count.value}");
});

count.value++;  // ✅ Automatically tracks dependencies
stop(); // ✅ Stops watching
```

#### `watch(List<ChangeNotifier> sources, Function callback, {bool immediate = false}) -> VoidCallback`

- Watches multiple `ChangeNotifier` sources.
- If `immediate = true`, executes the callback immediately.

#### Example:

```dart
final stop = watch([count], () {
  print("Count changed: ${count.value}");
}, immediate: true);

stop(); // ✅ Stops watching
```

### 4️⃣ **Asynchronous Derived State: `AsyncComputed<T>`**

Handles computed values that depend on asynchronous operations.

#### Parameters:

| Parameter      | Type                       | Description                                             |
| -------------- | -------------------------- | ------------------------------------------------------- |
| `getter`       | `Future<T> Function()`     | A function returning a future value.                    |
| `defaultValue` | `T?`                       | An optional initial value before computation completes. |
| `onError`      | `Function(dynamic error)?` | An optional error handler.                              |
| `immediate`    | `bool`                     | Whether to compute immediately.                         |

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
| `VueNotifier.toRef()`   | ✅        |

This package provides an intuitive and efficient reactivity system for Flutter, making state management much easier and more performant. 🚀

## 🛠 Contributing

Pull requests and feature requests are welcome! Feel free to open an issue or contribute.

## 📜 License

MIT License. See [LICENSE](LICENSE) for details.
