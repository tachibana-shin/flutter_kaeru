import 'package:flutter/widgets.dart';
import 'package:kaeru/kaeru.dart';

typedef UseWidgetSizeReturn = ({
  GlobalKey key,
  Ref<double?> width,
  Ref<double?> height
});

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
