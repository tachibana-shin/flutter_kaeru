import 'package:flutter/foundation.dart';

import '../composables/use_pick.dart';
import 'reactive_notifier.dart';
import '../event_bus.dart';

/// A raw watcher that can be used to track dependencies.
mixin class WatcherRaw<T> {
  /// A callback that is called when the watcher's dependencies change.
  late final VoidCallback onChange;
  /// A function that is called to track dependencies.
  late final T Function() dryRun;

  bool _firstRun = true;

  /// The set of notifiers that this watcher is listening to.
  @protected
  Set<ReactiveNotifier> watchers = {};
  Listenable? _listenable;

  /// A map of computes that are used by this watcher.
  Map<int, Picker> computes = {};
  /// The current index of the compute being used.
  int currentIndexCompute = 0;

  final Set<VoidCallback> _cleanups = {};

  /// Adds a dependency to this watcher.
  void addDepend(ReactiveNotifier ref) {
    watchers.add(ref);
  }

  /// Gets the current compute.
  Picker? getCC() {
    return computes[currentIndexCompute++];
  }

  /// Sets the current compute.
  Picker setCC(Picker cc) {
    return computes[currentIndexCompute - 1] = cc;
  }

  /// Registers a cleanup function to be called when the watcher is disposed.
  void onCleanup(VoidCallback callback) {
    _cleanups.add(callback);
  }

  void _runCleanup() {
    for (final cb in _cleanups) {
      cb();
    }
    _cleanups.clear();
  }

  /// Runs the watcher and returns the result.
  T run() {
    if (_firstRun) {
      _firstRun = false;
    } else {
      _runCleanup();
    }

    final oldWatchers = watchers;
    watchers = {};

    final oldWatcher = setCurrentWatcher(this);
    final output = dryRun();
    restoreCurrentWatcher(oldWatcher);

    if (!setEquals(watchers, oldWatchers)) {
      _listenable?.removeListener(onChange);
      if (watchers.isNotEmpty) {
        _listenable = Listenable.merge(watchers)..addListener(onChange);
      } else {
        _listenable = null;
      }
    } else {
      watchers = oldWatchers;
    }

    // clear computes not used
    for (int i = currentIndexCompute;; i++) {
      final compute = computes[i];
      if (compute == null) break;

      assert(!watchers.contains(compute.compute),
          'Watcher should not be used in computed');

      compute.dispose();
      computes.remove(i);
    }

    currentIndexCompute = 0;
    return output;
  }

  /// Disposes of the watcher.
  void dispose2() {
    _listenable?.removeListener(onChange);
    _listenable = null;

    watchers.clear();

    for (final compute in computes.values) {
      compute.dispose();
    }

    computes.clear();

    _runCleanup();
  }
}

/// A mixin that provides watcher functionality to a [ReactiveNotifier].
mixin Watcher<T> on WatcherRaw<T>, ReactiveNotifier<T> {
  @override
  void dispose() {
    dispose2();
    super.dispose();
  }
}