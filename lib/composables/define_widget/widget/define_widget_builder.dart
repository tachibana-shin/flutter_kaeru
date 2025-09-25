import 'package:flutter/material.dart';
import 'package:kaeru/kaeru.dart';
import '../main.dart';

/// A function that renders a widget.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
typedef FunctionRender = Widget Function(BuildContext context);

/// A widget builder that supports the `defineWidget` API.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
class DefineWidgetBuilder extends StatefulWidget {
  final FunctionRender Function(DefineWidgetBuilderState state) initState;
  final List<dynamic>? dependencies;
  final Widget Function(BuildContext context, FunctionRender render) build;

  const DefineWidgetBuilder(
      {required super.key,
      required this.initState,
      required this.dependencies,
      required this.build});

  @override
  createState() => DefineWidgetBuilderState();
}

/// The state for a [DefineWidgetBuilder].
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
class DefineWidgetBuilderState extends State<DefineWidgetBuilder>
    with KaeruLifeMixin {
  late final notifiersStore = <ChangeNotifier>{};
  late final disposesStore = <VoidCallback>{};

  late final FunctionRender _render;

  @override
  void initState() {
    super.initState();

    _render = widget.initState(this);
  }

  @override
  Widget build(context) {
    super.build(context);
    return widget.build(context, _render);
  }

  @override
  void dispose() {
    for (var notifier in notifiersStore) {
      notifier.dispose();
    }
    notifiersStore.clear();

    for (var fn in disposesStore) {
      fn();
    }
    disposesStore.clear();

    if (getCurrentState() == this) restoreCurrentState(null);

    super.dispose();
  }
}