import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:kaeru/foundation/shallow_computed.dart';

import 'ref.dart';

class RefList<T> extends Iterable<T> {
  late final Ref<List<T>> _value;
  late final List<T> _rawValue;

  final Map<int, ShallowComputed<T>> _storeitem = {};

  RefList(List<T> value) {
    _value = Ref(value);
    _rawValue = value;
    _value.addListener(() {});
  }

  void _cleanStoreitemLeak() {
    if (_storeitem.length > _rawValue.length) {
      for (int i = _rawValue.length; i < _storeitem.length; i++) {
        _storeitem[i]?.dispose();
        _storeitem.remove(i);
      }
    }
  }

  T operator [](int index) {
    return (_storeitem[index] ??= ShallowComputed(() => _rawValue[index]))
        .value;
  }

  operator []=(int index, T value) {
    _value.value[index] = value;
    _storeitem[index]?.notify();
    _value.notify();
  }

  void add(T element) {
    _value.value.add(element);
    _value.notify();
  }

  void insert(int index, T element) {
    _value.value.insert(index, element);
    for (int i = index; i < _rawValue.length; i++) {
      _storeitem[i]?.notify();
    }
    _value.notify();
  }

  bool remove(T element) {
    final index = _value.value.indexOf(element);
    if (index != -1) {
      final result = _value.value.remove(element);

      for (int i = index; i < _rawValue.length; i++) {
        _storeitem[i]?.notify();
      }

      _cleanStoreitemLeak();

      _value.notify();
      return result;
    }
    return false;
  }

  T removeAt(int index) {
    final result = _value.value.removeAt(index);

    for (int i = index; i < _rawValue.length; i++) {
      _storeitem[i]?.notify();
    }

    _cleanStoreitemLeak();

    _value.notify();
    return result;
  }

  void clear() {
    _storeitem.forEach((_, c) => c.dispose());
    _storeitem.clear();
    _value.value.clear();
    _value.notify();
  }

  @override
  bool contains(Object? element) => _value.value.contains(element);
  int indexOf(T element, [int start = 0]) =>
      _value.value.indexOf(element, start);
  int lastIndexOf(T element, [int? start]) =>
      _value.value.lastIndexOf(element, start);
  void sort([int Function(T a, T b)? compare]) {
    _value.value.sort(compare);
    _value.notify();
  }

  void shuffle([Random? random]) {
    _value.value.shuffle(random);
    _value.notify();
  }

  List<T> sublist(int start, [int? end]) => _value.value.sublist(start, end);
  void setAll(int index, Iterable<T> iterable) {
    _value.value.setAll(index, iterable);

    for (int i = index; i < _rawValue.length; i++) {
      _storeitem[i]?.notify();
    }

    _value.notify();
  }

  void fillRange(int start, int end, [T? fillValue]) {
    _value.value.fillRange(start, end, fillValue);

    for (int i = start; i < end; i++) {
      _storeitem[i]?.notify();
    }

    _value.notify();
  }

  void replaceRange(int start, int end, Iterable<T> newContents) {
    _value.value.replaceRange(start, end, newContents);

    for (int i = start; i < end; i++) {
      _storeitem[i]?.notify();
    }

    _value.notify();
  }

  void removeRange(int start, int end) {
    _value.value.removeRange(start, end);

    for (int i = start; i < _rawValue.length; i++) {
      _storeitem[i]?.notify();
    }

    _value.notify();
  }

  void retainWhere(bool Function(T element) test) {
    _value.value.retainWhere(test);
    _value.notify();
  }

  void removeWhere(bool Function(T element) test) {
    final list = _value.value;
    for (int i = list.length - 1; i >= 0; i--) {
      if (test(list[i])) {
        list.removeAt(i);
      }
    }

    for (int i = 0; i < _rawValue.length; i++) {
      _storeitem[i]?.notify();
    }

    _value.notify();
  }

  set length(int newLength) {
    _value.value.length = newLength;
    _value.notify();
  }

  @override
  int get length => _value.value.length;

  @override
  T elementAt(int index) => this[index];

  @override
  Iterator<T> get iterator => _value.value.iterator;

  @override
  String toString() => '${describeIdentity(this)}($_value)';

  void dispose() {
    _storeitem.forEach((key, value) => value.dispose());
    _storeitem.clear();
    _value.dispose();
  }

  @override
  List<T> toList({bool growable = true}) =>
      List<T>.from(_value.value, growable: growable);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is RefList<T> && other._value == _value);

  @override
  int get hashCode => _value.hashCode;
}
