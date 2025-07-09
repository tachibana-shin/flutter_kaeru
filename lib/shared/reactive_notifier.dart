import 'package:flutter/foundation.dart';

import '../foundation/computed.dart';

abstract class ReactiveNotifier<T> extends ChangeNotifier {
  bool _mounted = true;
  get mounted => _mounted;

  T get value;

  Computed<U> select<U>(U Function(T value) getter) {
    return Computed(() => getter(value));
  }
  // final Set<VoidCallback> _listeners = {};

  // void addListener(VoidCallback cb) {
  //   _listeners.add(cb);
  // }

  // void removeListener(VoidCallback cb) {
  //   _listeners.remove(cb);
  // }

  // void notifyListeners() {
  //   for (var cb in _listeners) {
  //     cb();
  //   }
  // }

  // void dispose() {
  //   _listeners.clear();
  // }

  @override
  void notifyListeners() {
    if (mounted) super.notifyListeners();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
