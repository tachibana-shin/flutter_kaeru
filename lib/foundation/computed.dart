import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';
import 'package:reactivity/event_bus.dart';
import 'package:reactivity/shared/watcher.dart';

import '../shared/reactive_notifier.dart';

class Computed<T> extends ReactiveNotifier with Watcher {
  late T _value;

  final T Function() _getValue;

  bool _initialized = false;
  bool _updated = false;

  Computed(this._getValue) {
    onChange = oneCallTask(() {
      _updated = false;
      _runDry();
    });
    dryRun = () => _value = _getValue();
  }

  void _runDry() {
    if (_updated) return;

    _updated = true;

    late final T? oldValue;
    if (_initialized) {
      oldValue = _value;
    } else {
      oldValue = null;
      _initialized = true;
    }

    run();

    if (_initialized && oldValue != _value) notifyListeners();
  }

  T get value {
    getCurrentWatcher()?.addDepend(this);
    _runDry();
    return _value;
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
