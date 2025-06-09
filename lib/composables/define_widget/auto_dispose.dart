import 'package:flutter/material.dart';

import 'composables/use_state.dart';

T autoContextDispose<T extends ChangeNotifier>(T notifier) {
  useState().notifiersStore.add(notifier);
  return notifier;
}

VoidCallback autoContextDisposeFn(VoidCallback fn) {
  useState().disposesStore.add(fn);
  return fn;
}
