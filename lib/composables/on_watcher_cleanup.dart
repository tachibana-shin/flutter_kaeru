import 'package:flutter/foundation.dart';

import 'shared/get_current_instance.dart';

void onWatcherCleanup(VoidCallback callback) {
  final currentWatcher = getCurrentInstance();

  currentWatcher.onCleanup(callback);
}
