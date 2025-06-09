import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kaeru/kaeru.dart';

enum HoverMode { mouse, touch, both, atomic }

typedef UseHoverWidgetReturn = ({
  Ref<bool> isHover,
  Widget Function(WidgetBuilder builder) hoverWrap,
});

UseHoverWidgetReturn useHoverWidget({HoverMode mode = HoverMode.atomic}) {
  final isHover = $ref(false);
  final key = GlobalKey();

  void setHover(bool value) {
    isHover.value = value;
  }

  // Determine effective mode
  HoverMode effectiveMode = mode;
  if (mode == HoverMode.atomic) {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      effectiveMode = HoverMode.touch;
    } else {
      effectiveMode = HoverMode.mouse;
    }
  }

  Widget hoverWrap(WidgetBuilder builder) {
    Widget child = Builder(builder: builder);

    if (effectiveMode == HoverMode.mouse || effectiveMode == HoverMode.both) {
      child = MouseRegion(
        onEnter: (_) => setHover(true),
        onExit: (_) => setHover(false),
        child: child,
      );
    }

    if (effectiveMode == HoverMode.touch || effectiveMode == HoverMode.both) {
      child = Listener(
        key: key,
        onPointerDown: (_) => setHover(true),
        onPointerUp: (_) => setHover(false),
        onPointerCancel: (_) => setHover(false),
        behavior: HitTestBehavior.translucent,
        child: child,
      );
    }

    return child;
  }

  return (
    isHover: isHover,
    hoverWrap: hoverWrap,
  );
}
