import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';

import '../shared/watcher.dart';

/// Sets up a reactive effect triggered by [callback] and returns a function
/// to dispose of the effect when it’s no longer needed.
VoidCallback watchEffect(VoidCallback callback) {
  final watcher = Watcher<void>();

  watcher.onChange = oneCallTask(watcher.run);
  watcher.dryRun = callback;
  
  watcher.onChange();

  return watcher.dispose;
}
