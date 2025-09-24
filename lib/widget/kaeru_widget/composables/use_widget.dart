import 'package:flutter/material.dart';

/// A custom hook to retrieve the current widget of a specific type from the context.
///
/// This hook asserts that the widget in the current context is of the specified type [T].
///
/// Example:
/// ```dart
/// final mySpecificWidget = useWidget<MySpecificWidget>();
/// ```
///
/// Parameters:
/// - `T`: The type of the widget that you want to retrieve from the context. This must be a subclass of [Widget].

import 'use_context.dart';

/// A custom hook to retrieve the current widget of a specific type from the context.
///
/// This hook asserts that the widget in the current context is of the specified type [T].
///
/// Example:
/// ```dart
/// final mySpecificWidget = useWidget<MySpecificWidget>();
/// ```

T useWidget<T extends Widget>() {
  final context = useContext();

  assert(context.widget is T, 'The type $T must be of type widget');

  return context.widget as T;
}
