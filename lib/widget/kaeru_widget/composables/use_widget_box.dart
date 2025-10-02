import 'package:flutter/material.dart';

import '../../../foundation/ref.dart';
import '../reactive.dart';

/// A data class holding the reactive box constraints and the builder function.
///
/// - `box`: A `Ref` containing the `BoxConstraints` of the widget.
/// - `builder`: A function that you wrap around your widget to capture its constraints.
class UseWidgetBox {
  final Ref<BoxConstraints?> box;
  final Widget Function(Widget Function() builder) builder;

  UseWidgetBox(this.box, this.builder);
}

/// A composable that provides the `BoxConstraints` of a widget reactively.
///
/// It returns a `UseWidgetBox` object containing a `Ref<BoxConstraints?>` and a `builder` function.
/// You must use the `builder` function to wrap the widget whose constraints you want to capture.
///
/// This is useful for creating layouts that adapt to the space they are given.
///
/// ### Example:
/// ```dart
/// KaeruWidget((ref) {
///   final widgetBox = useWidgetBox();
///   final constraints = widgetBox.box;
///
///   return KaeruBuilder(() {
///     return widgetBox.builder(() {
///       // This code will rebuild whenever the constraints change.
///       if (constraints.value == null) {
///         return const CircularProgressIndicator();
///       }
///       return Text(
///         'Max width: ${constraints.value!.maxWidth}\n'
///         'Max height: ${constraints.value!.maxHeight}',
///       );
///     });
///   });
/// });
/// ```
UseWidgetBox useWidgetBox() {
  final ret = ref<BoxConstraints?>(null);

  Widget template(Widget Function() builder) {
    return LayoutBuilder(builder: (context, constraints) {
      ret.value = constraints;

      return builder();
    });
  }

  return UseWidgetBox(ret, template);
}