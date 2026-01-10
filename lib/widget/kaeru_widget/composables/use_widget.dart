import 'package:flutter/material.dart';
import 'package:kaeru/foundation/computed.dart';
import 'package:kaeru/widget/kaeru_widget/life.dart';
import 'package:kaeru/widget/kaeru_widget/reactive.dart';
import 'use_context.dart';

/// A custom hook to retrieve the current widget of a specific type from the context.
///
/// This hook asserts that the widget in the current context is of the specified type [T].
///
/// Example:
/// ```dart
/// final mySpecificWidget = useWidget<MySpecificWidget>();
/// ```
Computed<T> useWidget<T extends Widget>() {
  final context = useContext();
  assert(context.widget is T, 'The type $T must be of type widget');

  final value = computed<T>(() => context.widget as T);
  onUpdated((_) => value.onChange());

  return value;
}
