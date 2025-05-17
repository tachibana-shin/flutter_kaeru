import 'package:flutter/foundation.dart';

import '../composables/use_pick.dart';
import 'reactive_notifier.dart';
import '../event_bus.dart';

mixin class WatcherRaw<T> {
  late final VoidCallback onChange;
  late final T Function() dryRun;

  @protected
  Set<ReactiveNotifier> watchers = {};
  Listenable? _listenable;

  Map<int, Picker> computes = {};
  int currentIndexCompute = 0;

  void addDepend(ReactiveNotifier ref) {
    watchers.add(ref);
  }

  Picker? getCC() {
    return computes[currentIndexCompute++];
  }

  Picker setCC(Picker cc) {
    return computes[currentIndexCompute - 1] = cc;
  }

  T run() {
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

      assert(!watchers.contains(compute),
          'Watcher should not be used in computed');

      compute.dispose();
      computes.remove(i);
    }

    currentIndexCompute = 0;
    return output;
  }

  void dispose2() {
    _listenable?.removeListener(onChange);
    _listenable = null;

    watchers.clear();

    for (final compute in computes.values) {
      compute.dispose();
    }

    computes.clear();
  }
}

mixin Watcher<T> on WatcherRaw<T>, ReactiveNotifier<T> {
  @override
  void dispose() {
    dispose2();
    super.dispose();
  }
}
