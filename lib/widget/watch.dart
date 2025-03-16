import 'package:flutter/material.dart';

import '../foundation/computed.dart';

class Watch extends StatefulWidget {
  final Widget Function(BuildContext context) builder;

  const Watch({super.key, required this.builder});

  @override
  State<Watch> createState() => _WatchState();
}

class _WatchState extends State<Watch> {
  late final Computed<Widget> _computed;
  @override
  void initState() {
    _computed = Computed(() => widget.builder(context))..addListener(_refresh);

    super.initState();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _computed.value;
  }

  @override
  void dispose() {
    _computed.removeListener(_refresh);
    super.dispose();
  }
}
