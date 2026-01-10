import 'package:flutter/widgets.dart';
import 'package:kaeru/foundation/computed.dart';
import 'package:kaeru/widget/kaeru_widget/composables/use_context.dart';
import 'package:kaeru/widget/kaeru_widget/life.dart';
import 'package:kaeru/widget/kaeru_widget/reactive.dart';

T _getInherited<T extends InheritedWidget>(BuildContext context) {
  final current = context.dependOnInheritedWidgetOfExactType<T>();

  if (current == null) {
    throw FlutterError(
      "useInherited<${T.runtimeType}>() could not find the inherited widget.",
    );
  }

  return current;
}

/// Reactive hook to read a value from an InheritedWidget.
/// It rebuilds when the inherited widget notifies update.
Computed<T> useInherited<T extends InheritedWidget>() {
  final context = useContext();
  final compute = computed<T>(() => _getInherited(context));

  // Register dependency and update when the InheritedWidget changes.
  onDependenciesChanged(() {
    // Depend on InheritedWidget and store it.
    compute.onChange();
  });

  // final current = value.value;
  // if (current == null) {
  //   throw FlutterError(
  //     "useInherited<${T.runtimeType}>() could not find the inherited widget.",
  //   );
  // }

  return compute;
}
