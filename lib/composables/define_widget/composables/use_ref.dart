import 'package:flutter/widgets.dart';

/// Creates a [GlobalKey] for a widget.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
GlobalKey useRef() {
  final key = GlobalKey();

  return key;
}