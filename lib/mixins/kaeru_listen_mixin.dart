import 'package:flutter/widgets.dart';

/// `KaeruListenMixin` provides a simple way to listen to `ChangeNotifier` updates within a `StatefulWidget`.
/// 
/// ✅ **Features:**
/// - `listen()`: Subscribes to a single `ChangeNotifier`.
/// - `listenAll()`: Subscribes to multiple `ChangeNotifier`s with a single callback.
/// - Returns a cancel function to remove listeners when necessary.
mixin KaeruListenMixin<T extends StatefulWidget> on State<T> {
  /// Stores the registered `ChangeNotifier` and its corresponding callback.
  final Map<ChangeNotifier, VoidCallback> _listenStore = {};

  /// Listens to a single `ChangeNotifier` and executes `callback` when it changes.
  ///
  /// Returns a function that can be called to unsubscribe from the notifier.
  VoidCallback listen(ChangeNotifier notifier, VoidCallback callback) {
    final existingCallback = _listenStore[notifier];
    if (existingCallback == null) {
      notifier.addListener(_listenStore[notifier] = callback);
    }
    return () {
      notifier.removeListener(callback);
      _listenStore.remove(notifier);
    };
  }

  /// Listens to multiple `ChangeNotifier`s and executes `callback` when any of them changes.
  ///
  /// Returns a function that can be called to unsubscribe from all notifiers at once.
  VoidCallback listenAll(Iterable<ChangeNotifier> notifiers, VoidCallback callback) {
    final List<VoidCallback> cancelCallbacks = [];

    for (var notifier in notifiers) {
      cancelCallbacks.add(listen(notifier, callback));
    }

    return () {
      for (var cancel in cancelCallbacks) {
        cancel();
      }
    };
  }

  @override
  void dispose() {
    for (var notifier in _listenStore.keys) {
      notifier.removeListener(_listenStore[notifier]!);
    }
    _listenStore.clear();
    super.dispose();
  }
}
