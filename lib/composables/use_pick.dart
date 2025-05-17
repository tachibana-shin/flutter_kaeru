import 'package:kaeru/event_bus.dart';
import 'package:kaeru/shared/reactive_notifier.dart';

import '../foundation/computed.dart';

class Picker<T> {
  final Computed<T> Function() _getCompute;
  Computed<T>? _compute;

  Picker(this._getCompute);

  T get value {
    if (_compute != null) return _compute!.value;

    return (_compute = _getCompute()).value;
  }

  void dispose() {
    _compute?.dispose();
    _compute = null;
  }
}

Picker<U> usePick<T, U>(ReactiveNotifier<T> ctx, U Function(T value) selector) {
  final currentWatcher = getCurrentWatcher();

  if (currentWatcher == null) throw Exception('No watcher found');

  var pickWatcher = currentWatcher.getCC();
  pickWatcher ??= currentWatcher
      .setCC(Picker<U>(() => Computed<U>(() => selector(ctx.value))));

  return pickWatcher as Picker<U>;
}
