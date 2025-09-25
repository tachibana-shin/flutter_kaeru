import 'package:flutter/widgets.dart';
import 'package:kaeru/kaeru.dart';
import '../main.dart';

/// Return type for [useWidgetSize].
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
typedef UseWidgetSizeReturn = ({
  GlobalKey key,
  Ref<double?> width,
  Ref<double?> height
});

/// A hook that provides the size of a widget.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
UseWidgetSizeReturn useWidgetSize(GlobalKey key) {
  final width = $ref<double?>(null);
  final height = $ref<double?>(null);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final context = key.currentContext;
    if (context != null) {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        width.value = renderBox.size.width;
        height.value = renderBox.size.height;
      }
    }
  });

  return (key: key, width: width, height: height);
}