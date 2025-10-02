import 'package:flutter/material.dart';

import '../../../foundation/ref.dart';
import '../reactive.dart';

/// A data class holding the reactive size and the builder function.
///
/// - `size`: A `Ref` containing the `Size` of the widget.
/// - `builder`: A function that you wrap around your widget to capture its size.
class UseWidgetSize {
  final Ref<Size?> size;
  final Widget Function(Widget Function() builder) builder;

  UseWidgetSize(this.size, this.builder);
}

/// A composable that provides the `Size` of a widget reactively.
///
/// It returns a `UseWidgetSize` object containing a `Ref<Size?>` and a `builder` function.
/// You must use the `builder` function to wrap the widget whose size you want to capture.
/// The size is derived from `constraints.biggest` in a `LayoutBuilder`.
///
/// This is useful for creating layouts that adapt to the size they are given.
///
/// ### Example:
/// ```dart
/// KaeruWidget((ref) {
///   final widgetSize = useWidgetSize();
///   final size = widgetSize.size;
///
///   return KaeruBuilder(() {
///     return widgetSize.builder(() {
///       // This code will rebuild whenever the size changes.
///       if (size.value == null) {
///         return const CircularProgressIndicator();
///       }
///       return Text(
///         'Width: ${size.value!.width}\n'
///         'Height: ${size.value!.height}',
///       );
///     });
///   });
/// });
/// ```
UseWidgetSize useWidgetSize() {
  final ret = ref<Size?>(null);

  Widget template(Widget Function() builder) {
    return LayoutBuilder(builder: (context, constraints) {
      ret.value = constraints.biggest;

      return builder();
    });
  }

  return UseWidgetSize(ret, template);
}