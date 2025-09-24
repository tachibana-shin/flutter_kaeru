import 'package:flutter/widgets.dart';
import 'package:kaeru/composables/define_widget/widget/define_widget_builder.dart';

import 'composables/use_state.dart';

void $onMounted(VoidCallback callback) {
  useState().onMounted(callback);
}

void $onDependenciesChanged(VoidCallback callback) {
  useState().onDependenciesChanged(callback);
}

void $onUpdated(void Function(DefineWidgetBuilder) callback) {
  useState().onUpdated(callback);
}

void $onBeforeUnmount(VoidCallback callback) {
  useState().onBeforeUnmount(callback);
}

void $onDeactivated(VoidCallback callback) {
  useState().onDeactivated(callback);
}
