import 'dart:math';
import 'package:kaeru/foundation/ref.dart';

/// Extensions that add convenient mutation operations for
/// a reactive `Ref<List<T>>`, automatically calling `notifyChange()`
/// after each update.
extension RefListExt<T> on Ref<List<T>> {
  // --------------------------------------------------
  // Operator helpers
  // --------------------------------------------------

  /// Adds a single value to the end of the list.
  ///
  /// Example:
  /// ```dart
  /// final items = Ref(<int>[]);
  /// items + 3; // [3]
  /// ```
  void operator +(T value) => add(value);

  /// Removes the first matching value from the list.
  ///
  /// Example:
  /// ```dart
  /// final items = Ref([1, 2, 3]);
  /// items - 2; // [1, 3]
  /// ```
  void operator -(T value) => remove(value);

  /// Sets the element at the given index.
  ///
  /// Example:
  /// ```dart
  /// final items = Ref(["a", "b"]);
  /// items[1] = "x"; // ["a", "x"]
  /// ```
  void operator []=(int index, T value) {
    $[index] = value;
    notifyChange();
  }

  /// Returns the element at the given index.
  T? operator [](int index) => $[index];

  // --------------------------------------------------
  // Basic mutation
  // --------------------------------------------------

  /// Adds a value and notifies listeners.
  ///
  /// ```dart
  /// final list = Ref(<int>[]);
  /// list.add(1); // [1]
  /// ```
  void add(T value) {
    $.add(value);
    notifyChange();
  }

  /// Adds multiple elements.
  ///
  /// ```dart
  /// list.addAll([1, 2, 3]);
  /// ```
  void addAll(Iterable<T> values) {
    $.addAll(values);
    notifyChange();
  }

  /// Removes the first matching value.
  ///
  /// Returns `true` if removed.
  bool remove(T value) {
    final result = $.remove(value);
    notifyChange();
    return result;
  }

  /// Removes element at an index.
  ///
  /// ```dart
  /// list.removeAt(1);
  /// ```
  T removeAt(int index) {
    final result = $.removeAt(index);
    notifyChange();
    return result;
  }

  /// Removes and returns the last element.
  T removeLast() {
    final result = $.removeLast();
    notifyChange();
    return result;
  }

  /// Removes elements that match the predicate.
  void removeWhere(bool Function(T element) test) {
    $.removeWhere(test);
    notifyChange();
  }

  /// Keeps only elements that satisfy [test].
  void retainWhere(bool Function(T element) test) {
    $.retainWhere(test);
    notifyChange();
  }

  /// Clears the list.
  void clear() {
    $.clear();
    notifyChange();
  }

  // --------------------------------------------------
  // Insert / Update
  // --------------------------------------------------

  /// Inserts an element at a given index.
  void insert(int index, T element) {
    $.insert(index, element);
    notifyChange();
  }

  /// Inserts all elements starting at [index].
  void insertAll(int index, Iterable<T> elements) {
    $.insertAll(index, elements);
    notifyChange();
  }

  /// Sets value at index (identical to `operator[]=`).
  void setAt(int index, T value) {
    $[index] = value;
    notifyChange();
  }

  // --------------------------------------------------
  // Sorting / Shuffling / Reverse
  // --------------------------------------------------

  /// Sorts the list in-place.
  ///
  /// ```dart
  /// list.sort();
  /// list.sort((a, b) => b.compareTo(a));
  /// ```
  void sort([int Function(T a, T b)? compare]) {
    $.sort(compare);
    notifyChange();
  }

  /// Randomly shuffles the list.
  void shuffle([Random? random]) {
    $.shuffle(random);
    notifyChange();
  }

  /// Replaces the list with its reversed order.
  ///
  /// ```dart
  /// list.reverse();
  /// ```
  void reverse() {
    value = $.reversed.toList();
  }

  // --------------------------------------------------
  // Utility
  // --------------------------------------------------

  /// Maps each element in-place.
  /// Useful for transforms without creating a new list.
  ///
  /// ```dart
  /// list.mapInPlace((e) => e * 2);
  /// ```
  void mapInPlace(T Function(T element) convert) {
    for (var i = 0; i < $.length; i++) {
      $[i] = convert($[i]);
    }
    notifyChange();
  }

  /// Fills a range with a value.
  ///
  /// Same as `List.fillRange`.
  void fillRange(int start, int end, T value) {
    $.fillRange(start, end, value);
    notifyChange();
  }

  /// Replaces a range with new elements.
  void replaceRange(int start, int end, Iterable<T> replacement) {
    $.replaceRange(start, end, replacement);
    notifyChange();
  }

  /// Sets a range of values from [source].
  void setRange(int start, int end, Iterable<T> source, [int skipCount = 0]) {
    $.setRange(start, end, source, skipCount);
    notifyChange();
  }

  /// Removes a range of elements.
  void removeRange(int start, int end) {
    $.removeRange(start, end);
    notifyChange();
  }

  /// Sets the new list length.
  ///
  /// ```dart
  /// list.length = 10;
  /// ```
  set length(int newLength) {
    $.length = newLength;
    notifyChange();
  }
}
