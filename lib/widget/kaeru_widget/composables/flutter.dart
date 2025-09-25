import 'dart:async';

/// Provides hooks for animation and tab controllers in Flutter.
///
/// This file includes functions to create `AnimationController` and `TabController`
/// with optional `vsync` parameter. If `vsync` is not provided, a single ticker state
/// will be created automatically.
///
/// Example usage of `useAnimationController`:
/// ```dart
/// final controller = useAnimationController(
///   duration: Duration(seconds: 1),
/// );
/// ```
///
/// Example usage of `useTabController`:
/// ```dart
/// final tabController = useTabController(
///   length: 3,
/// );
/// ```
import 'package:flutter/material.dart';

import '../life.dart';
import 'use_single_ticker_state.dart';

/// Creates an [AnimationController].
///
/// The controller is automatically disposed when the widget is unmounted.
AnimationController useAnimationController({
  /// An optional [vsync] parameter to synchronize the animation.
  /// If not provided, a ticker will be created automatically.
  TickerProvider? vsync,
  Duration? duration,
  String? debugLabel,
  double? lowerBound,
  double? upperBound,
  double? value,
  AnimationBehavior animationBehavior = AnimationBehavior.normal,
}) {
  vsync ??= useSingleTickerState();
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

/// Creates a [TabController].
///
/// The controller is automatically disposed when the widget is unmounted.
TabController useTabController({
  /// An optional [vsync] parameter to synchronize the tab animations.
  /// If not provided, a ticker will be created automatically.
  required int length,
  TickerProvider? vsync,
  int initialIndex = 0,
  Duration? animationDuration,
}) {
  vsync ??= useSingleTickerState();
  final c = TabController(
    length: length,
    vsync: vsync,
    initialIndex: initialIndex,
    animationDuration: animationDuration,
  );
  onBeforeUnmount(c.dispose);
  return c;
}

/// Creates a [ScrollController].
///
/// The controller is automatically disposed when the widget is unmounted.
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

/// Creates a [PageController].
///
/// The controller is automatically disposed when the widget is unmounted.
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

/// Creates a [TextEditingController].
///
/// The controller is automatically disposed when the widget is unmounted.
TextEditingController useTextEditingController([String? text]) {
  final c = TextEditingController(text: text);
  onBeforeUnmount(c.dispose);
  return c;
}

/// Creates a [FocusNode].
///
/// The node is automatically disposed when the widget is unmounted.
FocusNode useFocusNode({
  String? debugLabel,
  bool canRequestFocus = true,
  FocusOnKeyEventCallback? onKeyEvent,
  bool skipTraversal = false,
}) {
  final n = FocusNode(
    debugLabel: debugLabel,
    canRequestFocus: canRequestFocus,
    onKeyEvent: onKeyEvent,
    skipTraversal: skipTraversal,
  );
  onBeforeUnmount(n.dispose);
  return n;
}

/// Creates a [FocusScopeNode].
///
/// The node is automatically disposed when the widget is unmounted.
FocusScopeNode useFocusScopeNode({String? debugLabel}) {
  final n = FocusScopeNode(debugLabel: debugLabel);
  onBeforeUnmount(n.dispose);
  return n;
}

/// Creates a [ValueNotifier].
///
/// The notifier is automatically disposed when the widget is unmounted.
ValueNotifier<T> useValueNotifier<T>(T value) {
  final n = ValueNotifier<T>(value);
  onBeforeUnmount(n.dispose);
  return n;
}

/// Creates a [ChangeNotifier].
///
/// The notifier is automatically disposed when the widget is unmounted.
T useNotifier<T extends ChangeNotifier>(T notifier) {
  onBeforeUnmount(notifier.dispose);
  return notifier;
}

/// Creates a [TransformationController].
///
/// The controller is automatically disposed when the widget is unmounted.
TransformationController useTransformationController([Matrix4? value]) {
  final c = TransformationController(value);
  onBeforeUnmount(c.dispose);
  return c;
}

/// Creates a [StreamController].
///
/// The controller is automatically closed when the widget is unmounted.
StreamController<T> useStreamController<T>({
  bool sync = false,
}) {
  final c = StreamController<T>(sync: sync);
  onBeforeUnmount(c.close);
  return c;
}

/// Creates a [StreamSubscription].
///
/// The subscription is automatically cancelled when the widget is unmounted.
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

/// Creates a [Timer].
///
/// The timer is automatically cancelled when the widget is unmounted.
Timer useTimer(Duration duration, void Function() callback,
    {bool periodic = false}) {
  final timer = periodic
      ? Timer.periodic(duration, (_) => callback())
      : Timer(duration, callback);
  onBeforeUnmount(timer.cancel);
  return timer;
}

/// Creates an [OverlayEntry].
///
/// The entry is automatically removed when the widget is unmounted.
OverlayEntry useOverlayEntry(WidgetBuilder builder) {
  final entry = OverlayEntry(builder: builder);
  onBeforeUnmount(entry.remove);
  return entry;
}