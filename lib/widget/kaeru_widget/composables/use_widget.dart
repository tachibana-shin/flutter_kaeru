import 'package:flutter/material.dart';
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