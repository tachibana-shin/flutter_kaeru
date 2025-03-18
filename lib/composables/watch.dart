import 'package:flutter/foundation.dart';
import 'package:notifier_plus/notifier_plus.dart';

/// Sets up a watcher on the given [source] and triggers the [callback] when any
/// of the [Listenable] objects in the source change. If [immediate] is true,
/// the [callback] is triggered immediately after setting up the listener.
///
/// Returns a [VoidCallback] that can be used to remove the listener when it's
/// no longer needed.
VoidCallback watch(Iterable<Listenable?> source, VoidCallback callback,
    {bool immediate = false}) {
  // Wrap the callback in a one-call task to ensure it runs only once per change.
  callback = oneCallTask(callback);

  // Merge the source into a single Listenable and add the callback as a listener.
  final listenable = ((source.length == 1 ? source.first : null) ??
      Listenable.merge(source))
    ..addListener(callback);

  // If the immediate flag is true, call the callback immediately.
  if (immediate) callback();

  // Return a function to remove the listener when needed.
  return () => listenable.removeListener(callback);
}
