import 'package:flutter/foundation.dart';
import 'package:kaeru/widget/kaeru_widget/kaeru_widget.dart';

VoidCallback useListen(Listenable listen, VoidCallback listener) {
  listen.addListener(listener);

  void canceller() => listen.removeListener(listener);
  onBeforeUnmount(canceller);

  return canceller;
}
