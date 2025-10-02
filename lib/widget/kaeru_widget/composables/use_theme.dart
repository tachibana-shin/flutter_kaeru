import 'package:flutter/material.dart';

import 'use_context.dart';

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
///       'The primary color is ${theme.primaryColor}',
///       style: TextStyle(color: theme.colorScheme.secondary),
///     );
///   });
/// });
/// ```
ThemeData useTheme() {
  return Theme.of(useContext());
}