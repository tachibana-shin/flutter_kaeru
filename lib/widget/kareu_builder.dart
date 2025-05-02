import 'package:flutter/widgets.dart';
import 'package:kaeru/kaeru.dart';

class KaeruBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;

  const KaeruBuilder(this.builder, {super.key});

  @override
  createState() => _KaeruBuilderState();
}

class _KaeruBuilderState extends State<KaeruBuilder> with KaeruMixin {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
