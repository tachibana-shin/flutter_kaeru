import '../bus.dart';
import '../widget/define_widget_builder.dart';

/// Returns the [DefineWidgetBuilderState] of the current widget.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
DefineWidgetBuilderState useState() {
  final ctx = getCurrentState();
  if (ctx == null) throw Exception('Current context is null');
  return ctx;
}