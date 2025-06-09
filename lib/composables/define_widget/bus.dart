import 'widget/define_widget_builder.dart';

DefineWidgetBuilderState? _currentState;
DefineWidgetBuilderState? setCurrentState(DefineWidgetBuilderState state) {
  final old = _currentState;
  _currentState = state;
  return old;
}

DefineWidgetBuilderState? getCurrentState() => _currentState;
void restoreCurrentState(DefineWidgetBuilderState? state) =>
    _currentState = state;
