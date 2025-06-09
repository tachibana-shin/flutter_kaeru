import 'package:flutter/widgets.dart';

import 'composables/use_state.dart';

void $onMounted(VoidCallback callback) {
  useState().onMounted(callback);
}

void $onDependenciesChanged(VoidCallback callback) {
  useState().onDependenciesChanged(callback);
}

void $onUpdated(VoidCallback callback) {
  useState().onUpdated(callback);
}

void $onBeforeUnmount(VoidCallback callback) {
  useState().onBeforeUnmount(callback);
}

void $onDeactivated(VoidCallback callback) {
  useState().onDeactivated(callback);
}
