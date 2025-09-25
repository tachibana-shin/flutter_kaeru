import 'package:flutter/foundation.dart';

import 'shared/get_current_instance.dart';

/// Registers a cleanup function to be called when the watcher is disposed.
void onWatcherCleanup(VoidCallback callback) {
  final currentWatcher = getCurrentInstance();

  currentWatcher.onCleanup(callback);
}