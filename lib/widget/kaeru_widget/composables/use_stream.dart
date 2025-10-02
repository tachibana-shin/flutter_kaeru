import '../../../foundation/ref.dart';
import '../reactive.dart';

/// Subscribes to a [Stream] and returns a [Ref] that is updated with the latest value from the stream.
///
/// The returned [Ref] will have a `null` value until the stream emits its first value.
///
/// Example:
/// ```dart
/// final counterStream = Stream.periodic(Duration(seconds: 1), (i) => i);
/// final counter = useStream(counterStream);
///
/// // In your widget:
/// Text('${counter.value}'); // Will update every second
/// ```
Ref<T?> useStream<T>(Stream<T> stream) {
  final ret = ref<T?>(null);

  stream.listen((value) {
    ret.value = value;
  });

  return ret;
}

/// Subscribes to a [Stream] and returns a [Ref] that is updated with the latest value from the stream.
///
/// The returned [Ref] will have the `defaultValue` until the stream emits its first value.
///
/// Example:
/// ```dart
/// final counterStream = Stream.periodic(Duration(seconds: 1), (i) => i);
/// final counter = useStreamDefault(counterStream, defaultValue: 0);
///
/// // In your widget:
/// Text('${counter.value}'); // Will start at 0 and update every second
/// ```
Ref<T> useStreamDefault<T>(Stream<T> stream, {required T defaultValue}) {
  final ret = ref<T>(defaultValue);

  stream.listen((value) {
    ret.value = value;
  });

  return ret;
}