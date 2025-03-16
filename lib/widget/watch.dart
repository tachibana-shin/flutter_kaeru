import 'package:flutter/material.dart';

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
  final Widget Function(BuildContext context) builder;

  /// Creates a new [Watch] widget that rebuilds whenever the [builder]'s
  /// dependencies are updated.
  const Watch(this.builder, {super.key});

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
    _computed = Computed(() => widget.builder(context))..addListener(_refresh);
    super.initState();
  }

  /// Called when the computed value changes. Triggers a rebuild of this widget.
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
