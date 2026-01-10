import 'package:flutter/material.dart';
import 'package:kaeru/foundation/computed.dart';
import 'package:kaeru/widget/kaeru_widget/kaeru_widget.dart';

/// A composable that returns the current `ThemeData` from the widget tree.
///
/// This is a convenient way to access theme properties within a Kaeru composable.
/// It uses `useContext` to get the current `BuildContext` and then retrieves the theme.
///
/// ### Example:
/// ```dart
/// KaeruWidget((ref) {
///   final theme = useTheme();
///
///   return KaeruBuilder(() {
///     return Text(
///       'The primary color is ${theme.$.primaryColor}',
///       style: TextStyle(color: theme.$.colorScheme.secondary),
///     );
///   });
/// });
/// ```
Computed<ThemeData> useTheme() {
  final context = useContext();
  final compute = computed(() => Theme.of(context));

  onDependenciesChanged(() => compute.onChange());

  return compute;
}
