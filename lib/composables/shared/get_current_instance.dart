import '../../event_bus.dart';
import '../../shared/watcher.dart';
import '../exception/no_watcher_found_exception.dart';

WatcherRaw getCurrentInstance() {
  final currentWatcher = getCurrentWatcher();

  if (currentWatcher == null) throw NoWatcherFoundException('No watcher found');

  return currentWatcher;
}
