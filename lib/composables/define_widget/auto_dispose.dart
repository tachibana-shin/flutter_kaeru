import 'package:flutter/material.dart';

import 'composables/use_state.dart';

/// Schedules a [ChangeNotifier] to be disposed automatically when the widget
/// is unmounted.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
T autoContextDispose<T extends ChangeNotifier>(T notifier) {
  useState().notifiersStore.add(notifier);
  return notifier;
}

/// Schedules a function to be called automatically when the widget is unmounted.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
VoidCallback autoContextDisposeFn(VoidCallback fn) {
  useState().disposesStore.add(fn);
  return fn;
}