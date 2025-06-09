import '../bus.dart';
import '../widget/define_widget_builder.dart';

DefineWidgetBuilderState useState() {
  final ctx = getCurrentState();
  if (ctx == null) throw Exception('Current context is null');
  return ctx;
}
