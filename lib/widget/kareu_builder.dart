import 'package:flutter/widgets.dart';
import 'package:kaeru/kaeru.dart';

class KaeruBuilder extends StatefulWidget {
  final Widget Function(KaeruBuilderState context) builder;

  const KaeruBuilder({
    super.key,
    required this.builder,
  });

  @override
  createState() => KaeruBuilderState();
}

class KaeruBuilderState extends State<KaeruBuilder> with KaeruMixin {
  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }
}
