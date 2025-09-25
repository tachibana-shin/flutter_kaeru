import 'shared/watcher.dart';

WatcherRaw? _currentWatcher;

/// Sets the current [WatcherRaw] and returns the old one.
WatcherRaw? setCurrentWatcher(WatcherRaw? watcher) {
  final oldWatcher = _currentWatcher;
  _currentWatcher = watcher;
  return oldWatcher;
}

/// Gets the current [WatcherRaw].
WatcherRaw? getCurrentWatcher() {
  return _currentWatcher;
}

/// Restores the current [WatcherRaw].
restoreCurrentWatcher(WatcherRaw? oldWatcher) {
  _currentWatcher = oldWatcher;
}