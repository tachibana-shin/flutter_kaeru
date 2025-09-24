import 'package:flutter/material.dart';
import 'package:kaeru/kaeru.dart';
import '../main.dart';

typedef FunctionRender = Widget Function(BuildContext context);

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
