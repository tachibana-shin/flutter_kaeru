import 'package:flutter/foundation.dart';

import '../foundation/computed.dart';

/// An abstract class that provides a reactive notifier.
abstract class ReactiveNotifier<T> extends ChangeNotifier {
  bool _mounted = true;

  /// Whether the notifier is mounted.
  bool get mounted => _mounted;

  /// The current value of the notifier.
  T get value;

  /// Creates a [Computed] that selects a value from the notifier.
  Computed<U> select<U>(U Function(T value) getter) {
    return Computed(() => getter(value));
  }

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