import 'package:flutter/foundation.dart';

Future<void> nextTick([VoidCallback? callback]) async {
  await Future.delayed(Duration.zero);

  callback?.call();
}
