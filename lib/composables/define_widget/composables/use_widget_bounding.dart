import 'package:flutter/widgets.dart';
import 'package:kaeru/kaeru.dart';
import '../main.dart';

/// Represents the bounding box of a widget.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
class WidgetBounding {
  final double x;
  final double y;
  final double width;
  final double height;

  const WidgetBounding({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  double get top => y;
  double get left => x;
  double get right => x + width;
  double get bottom => y + height;
}

/// Return type for [useWidgetBounding].
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
typedef UseWidgetBoundingReturn = ({
  GlobalKey key,
  Computed<double?> x,
  Computed<double?> y,
  Computed<double?> top,
  Computed<double?> left,
  Computed<double?> right,
  Computed<double?> bottom,
  Computed<double?> width,
  Computed<double?> height,
});

/// A hook that provides the bounding box of a widget.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
UseWidgetBoundingReturn useWidgetBounding() {
  final key = GlobalKey();
  final bounding = $ref<WidgetBounding?>(null);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final context = key.currentContext;
    if (context == null) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    bounding.value = WidgetBounding(
      x: offset.dx,
      y: offset.dy,
      width: size.width,
      height: size.height,
    );
  });

  return (
    key: key,
    x: $computed(() => bounding.value?.x),
    y: $computed(() => bounding.value?.y),
    top: $computed(() => bounding.value?.top),
    left: $computed(() => bounding.value?.left),
    right: $computed(() => bounding.value?.right),
    bottom: $computed(() => bounding.value?.bottom),
    width: $computed(() => bounding.value?.width),
    height: $computed(() => bounding.value?.height),
  );
}