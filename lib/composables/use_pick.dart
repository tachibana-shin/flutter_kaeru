import 'package:kaeru/event_bus.dart';
import 'package:kaeru/shared/reactive_notifier.dart';

import '../foundation/computed.dart';

Computed<U> usePick<T, U>(
    ReactiveNotifier<T> ctx, U Function(T value) selector) {
  final currentWatcher = getCurrentWatcher();

  if (currentWatcher == null) throw Exception('No watcher found');

  var pickWatcher = currentWatcher.getCC();
  pickWatcher ??= currentWatcher.setCC(Computed<U>(() => selector(ctx.value)));

  return pickWatcher as Computed<U>;
}
