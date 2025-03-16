import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';

import '../shared/watcher.dart';

VoidCallback watchEffect(VoidCallback callback) {
  final watcher = Watcher<void>();

  watcher.onChange = oneCallTask(watcher.run);
  watcher.dryRun = callback;
  
  watcher.onChange();

  return watcher.dispose;
}
