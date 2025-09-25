import 'package:flutter/material.dart';
import 'package:kaeru/widget/kaeru_widget/kaeru_widget.dart';

/// Retrieves the current [BuildContext] from the [KaeruWidget].
///
/// This function must be called within a `KaeruWidget`.
BuildContext useContext() {
  final kaeru = useKaeruContext();
  assert(kaeru != null, 'useContext must be called within a KaeruWidget');

  return kaeru!.context;
}