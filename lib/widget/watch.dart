import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../foundation/computed.dart';

/// A widget that automatically rebuilds when dependencies used inside its
/// [builder] function change.
///
/// The [Watch] widget uses a [Computed] object to track changes in any reactive
/// dependencies accessed by the [builder], and triggers a rebuild whenever
/// those dependencies update.
class Watch extends StatefulWidget {
  /// A function that builds a widget tree given a [BuildContext]. It may read
  /// reactive values that, upon changing, will automatically cause this widget
  /// to rebuild.
  final Widget Function() builder;

  /// Optional dependencies. If this list changes (by content), [onUpdate] is triggered.
  final List<dynamic>? dependencies;

  const Watch(
    this.builder, {
    super.key,
    this.dependencies,
  });

  @override
  State<Watch> createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  /// A [Computed] object that computes the widget subtree via the [builder]
  /// function, listening for any reactive changes that trigger a rebuild.
  late final Computed<Widget> _computed;

  /// Initializes the [_computed] field and sets up a listener that triggers
  /// a rebuild when dependencies change.
  @override
  void initState() {
    super.initState();
    _computed = Computed(() => widget.builder())..addListener(_refresh);
  }

  @override
  void didUpdateWidget(covariant Watch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listEquals(widget.dependencies, oldWidget.dependencies)) {
      _computed.notify();
    }
  }

  void _refresh() {
    setState(() {});
  }

  /// Builds the widget subtree evaluated by the [_computed] object.
  @override
  Widget build(BuildContext context) {
    return _computed.value;
  }

  /// Removes the listener on [_computed] before disposing of the widget.
  @override
  void dispose() {
    _computed.removeListener(_refresh);
    _computed.dispose();
    super.dispose();
  }
}

extension WatchFnWidget<T extends Widget> on T Function() {
  Watch watch() => Watch(this);
}
