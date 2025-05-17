import 'shared/watcher.dart';

WatcherRaw? _currentWatcher;
WatcherRaw? setCurrentWatcher(WatcherRaw? watcher) {
  final oldWatcher = _currentWatcher;
  _currentWatcher = watcher;
  return oldWatcher;
}
WatcherRaw? getCurrentWatcher() {
  return _currentWatcher;
}

restoreCurrentWatcher(WatcherRaw? oldWatcher) {
  _currentWatcher = oldWatcher;
}
