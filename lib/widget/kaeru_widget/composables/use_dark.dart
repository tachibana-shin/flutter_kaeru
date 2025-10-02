import 'package:flutter/material.dart';
import 'package:kaeru/widget/kaeru_widget/composables/use_theme.dart';

import '../../../foundation/ref.dart';
import '../../watch.dart';
import '../reactive.dart';

/// A reactive utility to determine if the current theme is dark.
///
/// It provides a `useDark` composable to get a boolean `Ref` and
/// a `UseDark.builder` to rebuild a widget when the theme changes.
class UseDark {
  // private static instance
  static final UseDark _instance = UseDark._internal();

  Ref<bool>? mode;

  // private constructor
  UseDark._internal();

  /// Factory constructor to return the singleton instance.
  factory UseDark() {
    return _instance;
  }

  /// A builder that provides the current dark mode status.
  ///
  /// The `builder` function is called whenever the theme brightness changes.
  ///
  /// ### Example:
  /// ```dart
  /// UseDark.builder(
  ///   context,
  ///   (isDark) => Text(isDark ? 'It is dark' : 'It is light'),
  /// )
  /// ```
  static Widget builder(
          BuildContext ctx, Widget Function(bool isDark) builder) =>
      Watch(() {
        final dark = UseDark();

        dark.mode ??= ref(Theme.of(ctx).brightness == Brightness.dark);

        return builder(dark.mode!.value);
      });
}

/// A composable that returns a reactive boolean `Ref` indicating if the
/// current theme is dark.
///
/// The value of the `Ref` will update automatically when the theme changes.
///
/// ### Example:
/// ```dart
/// KaeruWidget((ref) {
///   final isDark = useDark();
///
///   return KaeruBuilder(() {
///     return Container(
///       color: isDark.value ? Colors.black : Colors.white,
///       child: Text(
///         isDark.value ? 'Dark Mode' : 'Light Mode',
///         style: TextStyle(
///           color: isDark.value ? Colors.white : Colors.black,
///         ),
///       ),
///     );
///   });
/// });
/// ```
Ref<bool> useDark() {
  final theme = useTheme();
  final dark = UseDark();

  dark.mode ??= ref(theme.brightness == Brightness.dark);

  return dark.mode!;
}