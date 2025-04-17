import 'package:flutter/foundation.dart';

import 'reactive_notifier.dart';
import '../event_bus.dart';

mixin class Watcher<T> {
  late final VoidCallback onChange;
  late final T Function() dryRun;

  @protected
  Set<ReactiveNotifier> watchers = {};
  Listenable? _listenable;

  void addDepend(ReactiveNotifier ref) {
    watchers.add(ref);
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

    return output;
  }

  void dispose() {
    _listenable?.removeListener(onChange);
    _listenable = null;
  }
}
