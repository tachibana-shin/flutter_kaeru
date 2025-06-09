import 'package:flutter/material.dart';

import 'bus.dart';

T autoContextDispose<T extends ChangeNotifier>(T notifier) {
  final ctx = getCurrentState();
  if (ctx == null) throw Exception('Current context is null');

  ctx.notifiersStore.add(notifier);
  return notifier;
}

VoidCallback autoContextDisposeFn(VoidCallback fn) {
  final ctx = getCurrentState();
  if (ctx == null) throw Exception('Current context is null');

  ctx.disposesStore.add(fn);
  return fn;
}
