import 'package:kaeru/foundation/ref.dart';

extension RefMapExt<K, V> on Ref<Map<K, V>> {
  /// Set value for key
  void operator []=(K key, V value) {
    $[key] = value;
    notifyChange();
  }

  /// Get value like normal
  V? operator [](K key) => $[key];

  void operator +(MapEntry<K, V> entry) {
    $[entry.key] = entry.value;
    notifyChange();
  }

  void operator -(K key) {
    remove(key);
  }

  // --- Basic mutation ---

  V putIfAbsent(K key, V Function() value) {
    final result = $.putIfAbsent(key, value);
    notifyChange();
    return result;
  }

  V? remove(K key) {
    final v = $.remove(key);
    notifyChange();
    return v;
  }

  void addAll(Map<K, V> other) {
    $.addAll(other);
    notifyChange();
  }

  void clear() {
    $.clear();
    notifyChange();
  }

  // --- Query ---

  bool containsKey(K key) => $.containsKey(key);
  bool containsValue(V value) => $.containsValue(value);

  // --- In-place updates ---

  void updateValue(K key, V Function(V old) updater) {
    final old = $[key];
    if (old != null) {
      this[key] = updater(old);
    }
  }

  void updateAllValues(V Function(K key, V value) updater) {
    $.updateAll(updater);
    notifyChange();
  }

  void removeWhere(bool Function(K key, V value) test) {
    $.removeWhere(test);
    notifyChange();
  }

  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final result = $.update(key, update, ifAbsent: ifAbsent);
    notifyChange();
    return result;
  }

  // --- Convenience ---

  void toggle(K key, V Function() buildValue) {
    if ($.containsKey(key)) {
      $.remove(key);
    } else {
      $.putIfAbsent(key, buildValue);
    }
    notifyChange();
  }
}
