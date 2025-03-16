import 'shared/watcher.dart';

Watcher? _currentWatcher;
Watcher? setCurrentWatcher(Watcher? watcher) {
  final oldWatcher = _currentWatcher;
  _currentWatcher = watcher;
  return oldWatcher;
}
Watcher? getCurrentWatcher() {
  return _currentWatcher;
}

restoreCurrentWatcher(Watcher? oldWatcher) {
  _currentWatcher = oldWatcher;
}
