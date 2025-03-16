import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';

VoidCallback watch(Iterable<Listenable?> source, VoidCallback callback,
    {bool immediate = false}) {
  callback = oneCallTask(callback);

  final listenable = Listenable.merge(source)..addListener(callback);

  if (immediate) callback();

  return () => listenable.removeListener(callback);
}
