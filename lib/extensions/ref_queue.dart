import 'dart:collection';

import 'package:kaeru/foundation/ref.dart';

/// Reactive extensions for a [Ref] that stores a [Queue].
///
/// Every mutation will call `notifyChange()` to ensure reactivity updates.
/// The API mirrors the native [Queue] mutation methods.
extension RefQueueExt<T> on Ref<Queue<T>> {
  /// Adds an element to the end of the queue.
  ///
  /// ### Example
  /// ```dart
  /// final q = Ref(Queue<int>());
  /// q.add(1); // queue: [1]
  /// q.add(2); // queue: [1, 2]
  /// ```
  void add(T value) {
    $.addLast(value);
    notifyChange();
  }

  /// Adds an element to the front of the queue.
  ///
  /// ### Example
  /// ```dart
  /// final q = Ref(Queue<int>());
  /// q.add(2);
  /// q.addFirst(1); // queue: [1, 2]
  /// ```
  void addFirst(T value) {
    $.addFirst(value);
    notifyChange();
  }

  /// Removes and returns the first element.
  ///
  /// ### Example
  /// ```dart
  /// final q = Ref(Queue.of([1, 2, 3]));
  /// final x = q.removeFirst(); // x = 1
  /// ```
  T removeFirst() {
    final v = $.removeFirst();
    notifyChange();
    return v;
  }

  /// Removes and returns the last element.
  ///
  /// ### Example
  /// ```dart
  /// final q = Ref(Queue.of([1, 2, 3]));
  /// final x = q.removeLast(); // x = 3
  /// ```
  T removeLast() {
    final v = $.removeLast();
    notifyChange();
    return v;
  }

  /// Clears all elements in the queue.
  ///
  /// ### Example
  /// ```dart
  /// final q = Ref(Queue.of([1, 2, 3]));
  /// q.clear(); // queue: []
  /// ```
  void clear() {
    $.clear();
    notifyChange();
  }
}
