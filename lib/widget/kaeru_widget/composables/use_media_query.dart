import 'package:flutter/widgets.dart';
import 'package:kaeru/foundation/computed.dart';
import 'package:kaeru/widget/kaeru_widget/kaeru_widget.dart';

Computed<MediaQueryData> useMediaQuery() {
  final context = useContext();
  final compute = computed(() => MediaQuery.of(context));

  onDependenciesChanged(() => compute.onChange());

  return compute;
}
