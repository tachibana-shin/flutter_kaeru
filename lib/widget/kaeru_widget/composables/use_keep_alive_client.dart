import 'package:flutter/material.dart';
import 'package:kaeru/mixins/kaeru_life_mixin.dart';

import 'package:kaeru/widget/kaeru_widget/life.dart';

import 'use_context.dart';

/// A hook that provides an [AutomaticKeepAliveClientMixin] for keeping a widget alive
/// even when it is not visible.
///
/// This is useful for preserving the state of a widget when it is removed from the
/// widget tree and later reinserted.
///
/// Example:
/// ```dart
/// final keepAliveClient = useKeepAliveClient();
/// ```
AutomaticKeepAliveClientMixin useKeepAliveClient(
    {
    /// A boolean value indicating whether the widget should be kept alive.
    /// If true, the widget will maintain its state when it is not visible.
    /// Default is true.
    bool wantKeepAlive = true}) {
  final context = useContext();
  final keepAlive = _KeepAliveClient(context, wantKeepAlive);

  keepAlive.initState();
  onDeactivated(keepAlive.deactivate);
  onBeforeBuild(keepAlive.build);

  return keepAlive;
}

class _KeepAliveClient extends State<StatefulWidget>
    with AutomaticKeepAliveClientMixin {
  late final BuildContext _contextOutside;
  late final bool _wantKeepAliveOutside;

  _KeepAliveClient(BuildContext context, bool watKeepAliveOutside) {
    _contextOutside = context;
    _wantKeepAliveOutside = watKeepAliveOutside;
  }

  @override
  get context => _contextOutside;
  @override
  get wantKeepAlive => _wantKeepAliveOutside;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const NullWidget();
  }
}