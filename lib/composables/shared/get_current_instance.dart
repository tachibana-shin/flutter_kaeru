import '../../event_bus.dart';
import '../../shared/watcher.dart';
import '../exception/no_watcher_found_exception.dart';

/// Returns the current [WatcherRaw] instance.
///
/// Throws a [NoWatcherFoundException] if no watcher is currently active.
WatcherRaw getCurrentInstance() {
  final currentWatcher = getCurrentWatcher();

  if (currentWatcher == null) throw NoWatcherFoundException('No watcher found');

  return currentWatcher;
}