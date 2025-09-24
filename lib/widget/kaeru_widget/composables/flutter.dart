import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kaeru/kaeru.dart';

/// --- Animation & Tab ---
AnimationController useAnimationController({
  required TickerProvider vsync,
  Duration? duration,
  String? debugLabel,
  double? lowerBound,
  double? upperBound,
  double? value,
  AnimationBehavior animationBehavior = AnimationBehavior.normal,
}) {
  final c = AnimationController(
    vsync: vsync,
    duration: duration,
    debugLabel: debugLabel,
    lowerBound: lowerBound ?? 0.0,
    upperBound: upperBound ?? 1.0,
    value: value,
    animationBehavior: animationBehavior,
  );
  onBeforeUnmount(c.dispose);
  return c;
}

TabController useTabController({
  required int length,
  required TickerProvider vsync,
  int initialIndex = 0,
  Duration? animationDuration,
}) {
  final c = TabController(
    length: length,
    vsync: vsync,
    initialIndex: initialIndex,
    animationDuration: animationDuration,
  );
  onBeforeUnmount(c.dispose);
  return c;
}

/// --- Scroll / Page ---
ScrollController useScrollController({
  double initialScrollOffset = 0.0,
  bool keepScrollOffset = true,
  String? debugLabel,
}) {
  final c = ScrollController(
    initialScrollOffset: initialScrollOffset,
    keepScrollOffset: keepScrollOffset,
    debugLabel: debugLabel,
  );
  onBeforeUnmount(c.dispose);
  return c;
}

PageController usePageController({
  int initialPage = 0,
  bool keepPage = true,
  double viewportFraction = 1.0,
}) {
  final c = PageController(
    initialPage: initialPage,
    keepPage: keepPage,
    viewportFraction: viewportFraction,
  );
  onBeforeUnmount(c.dispose);
  return c;
}

/// --- Text ---
TextEditingController useTextEditingController([String? text]) {
  final c = TextEditingController(text: text);
  onBeforeUnmount(c.dispose);
  return c;
}

/// --- Focus ---
FocusNode useFocusNode({
  String? debugLabel,
  bool canRequestFocus = true,
  FocusOnKeyCallback? onKey,
  bool skipTraversal = false,
}) {
  final n = FocusNode(
    debugLabel: debugLabel,
    canRequestFocus: canRequestFocus,
    onKey: onKey,
    skipTraversal: skipTraversal,
  );
  onBeforeUnmount(n.dispose);
  return n;
}

FocusScopeNode useFocusScopeNode({String? debugLabel}) {
  final n = FocusScopeNode(debugLabel: debugLabel);
  onBeforeUnmount(n.dispose);
  return n;
}

/// --- Notifiers ---
ValueNotifier<T> useValueNotifier<T>(T value) {
  final n = ValueNotifier<T>(value);
  onBeforeUnmount(n.dispose);
  return n;
}

T useNotifier<T extends ChangeNotifier>(T notifier) {
  onBeforeUnmount(notifier.dispose);
  return notifier;
}

/// --- TransformationController ---
TransformationController useTransformationController([Matrix4? value]) {
  final c = TransformationController(value);
  onBeforeUnmount(c.dispose);
  return c;
}

/// --- StreamController ---
StreamController<T> useStreamController<T>({
  bool sync = false,
}) {
  final c = StreamController<T>(sync: sync);
  onBeforeUnmount(c.close);
  return c;
}

/// --- StreamSubscription ---
StreamSubscription<T> useStreamSubscription<T>(
  Stream<T> stream,
  void Function(T event)? onData, {
  Function? onError,
  void Function()? onDone,
  bool? cancelOnError,
}) {
  final sub = stream.listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
  onBeforeUnmount(sub.cancel);
  return sub;
}

/// --- Timer ---
Timer useTimer(Duration duration, void Function() callback, {bool periodic = false}) {
  final timer = periodic
      ? Timer.periodic(duration, (_) => callback())
      : Timer(duration, callback);
  onBeforeUnmount(timer.cancel);
  return timer;
}

OverlayEntry useOverlayEntry(WidgetBuilder builder) {
  final entry = OverlayEntry(builder: builder);
  onBeforeUnmount(entry.remove);
  return entry;
}
