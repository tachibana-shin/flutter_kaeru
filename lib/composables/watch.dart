import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';

import '../event_bus.dart';
import '../shared/watcher.dart';

/// Sets up a watcher on the given [source] and triggers the [callback] when any
/// of the [Listenable] objects in the source change. If [immediate] is true,
/// the [callback] is triggered immediately after setting up the listener.
///
/// Returns a [VoidCallback] that can be used to remove the listener when it's
/// no longer needed.
///
/// The `$` suffix is used to indicate that this is a low-level function that
/// should be used with caution.
VoidCallback watch$(
  Iterable<Listenable?> source,
  VoidCallback callback, {
  bool immediate = false,
}) {
  final watcher = WatcherRaw<void>();

  bool firstRun = true;

  // Wrap the callback in a one-call task to ensure it runs only once per change.
  final callback2 = oneCallTask(() {
    if (firstRun) {
      firstRun = false;
    } else {
      watcher.dispose2();
    }

    final oldWatcher = setCurrentWatcher(watcher);

    callback();

    restoreCurrentWatcher(oldWatcher);
  });

  // Merge the source into a single Listenable and add the callback as a listener.
  final listenable =
      ((source.length == 1 ? source.first : null) ?? Listenable.merge(source))
        ..addListener(callback2);

  // If the immediate flag is true, call the callback immediately.
  if (immediate) callback2();

  // Return a function to remove the listener when needed.
  return () {
    watcher.dispose2();
    listenable.removeListener(callback2);
  };
}
