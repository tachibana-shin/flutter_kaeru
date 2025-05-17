import 'package:kaeru/shared/reactive_notifier.dart';

import '../foundation/computed.dart';
import 'shared/get_current_instance.dart';

class Picker<T> {
  final Computed<T> Function() _getCompute;
  Computed<T>? compute;

  Picker(this._getCompute);

  T get value {
    if (compute != null) return compute!.value;

    return (compute = _getCompute()).value;
  }

  void dispose() {
    compute?.dispose();
    compute = null;
  }
}

Picker<U> usePick<T, U>(ReactiveNotifier<T> ctx, U Function(T value) selector) {
  final currentWatcher = getCurrentInstance();

  var pickWatcher = currentWatcher.getCC();
  pickWatcher ??= currentWatcher
      .setCC(Picker<U>(() => Computed<U>(() => selector(ctx.value))));

  return pickWatcher as Picker<U>;
}
