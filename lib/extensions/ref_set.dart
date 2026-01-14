import 'package:kaeru/foundation/ref.dart';

/// Reactive extensions for a [Ref] that stores a [Set].
///
/// Mọi mutation đều gọi `notifyChange()`
/// để đảm bảo các Watch/Computed đều cập nhật đúng.
extension RefSetExt<T> on Ref<Set<T>> {
  // --- Operator sugar --------------------------------------------------------

  /// Adds [value] to the set.
  ///
  /// ```dart
  /// final s = Ref(<int>{});
  /// s + 1; // -> {1}
  /// ```
  void operator +(T value) {
    add(value);
  }

  /// Removes [value] from the set.
  ///
  /// ```dart
  /// final s = Ref({1, 2});
  /// s - 1; // -> {2}
  /// ```
  void operator -(T value) {
    remove(value);
  }

  // --- Basic mutation --------------------------------------------------------

  /// Adds a single value to the set.
  ///
  /// Returns `true` nếu phần tử được thêm mới;
  /// `false` nếu set đã chứa nó.
  ///
  /// ```dart
  /// final s = Ref(<int>{});
  /// s.add(10); // true
  /// s.add(10); // false
  /// ```
  bool add(T value) {
    final result = $.add(value);
    notifyChange();
    return result;
  }

  /// Adds all items in [elements].
  ///
  /// ```dart
  /// final s = Ref(<int>{});
  /// s.addAll([1, 2, 3]);
  /// ```
  void addAll(Iterable<T> elements) {
    $.addAll(elements);
    notifyChange();
  }

  /// Removes a single value.
  ///
  /// ```dart
  /// final s = Ref({1, 2});
  /// s.remove(1); // true
  /// ```
  bool remove(T value) {
    final result = $.remove(value);
    notifyChange();
    return result;
  }

  /// Removes all items in [elements].
  ///
  /// ```dart
  /// final s = Ref({1, 2, 3});
  /// s.removeAll([1, 3]); // -> {2}
  /// ```
  void removeAll(Iterable<T> elements) {
    $.removeAll(elements);
    notifyChange();
  }

  /// Keeps only elements that satisfy [test].
  ///
  /// ```dart
  /// final s = Ref({1, 2, 3, 4});
  /// s.retainWhere((e) => e.isEven); // -> {2, 4}
  /// ```
  void retainWhere(bool Function(T element) test) {
    $.removeWhere((e) => !test(e));
    notifyChange();
  }

  /// Removes every element that satisfies [test].
  ///
  /// ```dart
  /// final s = Ref({1, 2, 3});
  /// s.removeWhere((e) => e.isOdd); // -> {2}
  /// ```
  void removeWhere(bool Function(T element) test) {
    $.removeWhere(test);
    notifyChange();
  }

  /// Clears the entire set.
  ///
  /// ```dart
  /// final s = Ref({1,2,3});
  /// s.clear(); // -> {}
  /// ```
  void clear() {
    $.clear();
    notifyChange();
  }

  // --- Utility ---------------------------------------------------------------

  /// Toggles presence of [value].
  ///
  /// Nếu phần tử đã tồn tại -> xoá.
  /// Nếu chưa có -> thêm.
  ///
  /// ```dart
  /// final s = Ref(<int>{});
  /// s.toggle(5); // {5}
  /// s.toggle(5); // {}
  /// ```
  void toggle(T value) {
    if ($.contains(value)) {
      $.remove(value);
    } else {
      $.add(value);
    }
    notifyChange();
  }

  /// Maps every element using [convert], in-place.
  ///
  /// Set không thể mutate theo index nên cần tạo set mới.
  ///
  /// ```dart
  /// final s = Ref({'a', 'bb'});
  /// s.mapInPlace((e) => e.length); // -> {1, 2}
  /// ```
  void mapInPlace(T Function(T) convert) {
    final newSet = $.map(convert).toSet();
    $.clear();
    $.addAll(newSet);
    notifyChange();
  }

  /// Retains only elements that exist in [elements].
  ///
  /// ```dart
  /// final s = Ref({1, 2, 3, 4});
  /// s.retainAll([2, 4, 6]); // -> {2, 4}
  /// ```
  void retainAll(Iterable<T> elements) {
    $.retainAll(elements);
    notifyChange();
  }
}
