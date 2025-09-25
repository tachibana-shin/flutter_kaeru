import 'package:flutter/foundation.dart';

/// Defers the execution of a callback until the next event loop iteration.
Future<void> nextTick([VoidCallback? callback]) async {
  await Future.delayed(Duration.zero);

  callback?.call();
}