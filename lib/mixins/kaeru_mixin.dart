
import 'package:flutter/widgets.dart';

import '../foundation/computed.dart';
import '../foundation/ref.dart';

/// A mixin for `State` classes, providing helper methods to create reactive
/// values and computations.
/// 
/// This mixin defines two methods: [ref] and [computed].  Use [ref] to
/// create a reactive reference that notifies listeners of changes, and
/// use [computed] to define a lazy-evaluated value that automatically
/// updates whenever its dependencies change.
mixin KaeruMixin<T extends StatefulWidget> on State<T> {
  /// Creates a reactive [Ref] with the given initial [value]. This can be
  /// used to store and notify changes to a mutable value over the lifetime
  /// of the widget.
  Ref<U> ref<U>(U value) => Ref(value);

  /// Creates a reactive [Computed] with the provided [getter] function.
  /// The value is recomputed only when dependencies change and is guaranteed
  /// to notify listeners when it is updated.
  Computed<U> computed<U>(U Function() getter) => Computed(getter);
}
