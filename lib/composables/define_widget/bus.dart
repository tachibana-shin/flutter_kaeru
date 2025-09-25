import 'widget/define_widget_builder.dart';

/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
DefineWidgetBuilderState? _currentState;

/// Sets the current [DefineWidgetBuilderState] and returns the old one.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
DefineWidgetBuilderState? setCurrentState(DefineWidgetBuilderState state) {
  final old = _currentState;
  _currentState = state;
  return old;
}

/// Gets the current [DefineWidgetBuilderState].
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
DefineWidgetBuilderState? getCurrentState() => _currentState;

/// Restores the current [DefineWidgetBuilderState].
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
void restoreCurrentState(DefineWidgetBuilderState? state) =>
    _currentState = state;