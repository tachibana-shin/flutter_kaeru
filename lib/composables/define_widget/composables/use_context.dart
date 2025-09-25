import 'package:flutter/material.dart';

import 'use_state.dart';

/// Returns the [BuildContext] of the current widget.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
BuildContext useContext() {
  return useState().context;
}