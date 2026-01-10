import '../foundation/computed.dart';
import 'shared/get_current_instance.dart';

/// A class that memoizes a [Computed] value.
class Picker<T> {
  final Computed<T> Function() _getCompute;
  Computed<T>? compute;

  Picker(this._getCompute);

  T get value {
    if (compute != null) return compute!.value;

    return (compute = _getCompute()).value;
  }

  T? get $ => value;

  void dispose() {
    compute?.dispose();
    compute = null;
  }
}

/// Memoizes a [Computed] value and returns a [Picker] that can be used to
/// access the value.
Picker<T> usePick<T>(T Function() selector) {
  final currentWatcher = getCurrentInstance();

  var pickWatcher = currentWatcher.getCC();
  pickWatcher ??= currentWatcher.setCC(Picker<T>(() => Computed<T>(selector)));

  return pickWatcher as Picker<T>;
}
