import 'package:flutter/foundation.dart';
import 'package:reactivity/event_bus.dart';

import '../composables/watch_effect.dart';
import '../shared/reactive_notifier.dart';

class AsyncComputed<T> extends ReactiveNotifier {
  late T? _value;
  final void Function(dynamic error)? onError;

  final Future<T> Function() _getValue;

  bool _initialized = false;
  VoidCallback? _cancel;

  AsyncComputed(this._getValue, {T? defaultValue, this.onError, immediate = false}) {
    _value = defaultValue;
    if (immediate) _runDry();
  }

  void _runDry() {
    if (_initialized) return;
    _initialized = true;

    int currentId = -1;
    _cancel = watchEffect(() async {
      final id = ++currentId;

      final value = await _getValue();
      if (currentId == id && _value != value) {
        _value = value;
        notifyListeners();
      }
    });
  }

  T? get value {
    getCurrentWatcher()?.addDepend(this);
    _runDry();
    return _value;
  }

  @override
  void dispose() {
    _cancel?.call();
    super.dispose();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
