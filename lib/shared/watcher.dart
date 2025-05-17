import 'package:flutter/foundation.dart';

import '../foundation/computed.dart';
import 'reactive_notifier.dart';
import '../event_bus.dart';

mixin class WatcherRaw<T> {
  late final VoidCallback onChange;
  late final T Function() dryRun;

  @protected
  Set<ReactiveNotifier> watchers = {};
  Listenable? _listenable;

  List<Computed> computes = [];
  int currentIndexCompute = 0;

  void addDepend(ReactiveNotifier ref) {
    watchers.add(ref);
  }

  Computed? getCC() {
    return this.computes.elementAtOrNull(currentIndexCompute++);
  }

  Computed setCC(Computed cc) {
    return this.computes[currentIndexCompute - 1] = cc;
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

    currentIndexCompute = 0;
    return output;
  }

  void dispose2() {
    _listenable?.removeListener(onChange);
    _listenable = null;

    watchers.clear();

    for (final compute in computes) {
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