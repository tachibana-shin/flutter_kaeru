import 'package:flutter/widgets.dart';
import 'package:kaeru/composables/define_widget/widget/define_widget_builder.dart';

import 'composables/use_state.dart';

/// Registers a callback to be called when the widget is first mounted.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
void $onMounted(VoidCallback callback) {
  useState().onMounted(callback);
}

/// Registers a callback to be called when the widget's dependencies change.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
void $onDependenciesChanged(VoidCallback callback) {
  useState().onDependenciesChanged(callback);
}

/// Registers a callback to be called when the widget is updated.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
void $onUpdated(void Function(DefineWidgetBuilder) callback) {
  useState().onUpdated(callback);
}

/// Registers a callback to be called before the widget is unmounted.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
void $onBeforeUnmount(VoidCallback callback) {
  useState().onBeforeUnmount(callback);
}

/// Registers a callback to be called when the widget is deactivated.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
void $onDeactivated(VoidCallback callback) {
  useState().onDeactivated(callback);
}