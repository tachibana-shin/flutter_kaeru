import 'package:flutter/material.dart';
import 'package:kaeru/widget/kaeru_widget/kaeru_widget.dart';

BuildContext useContext() {
  /// Retrieves the current context from the Kaeru widget.
  ///
  /// This function must be called within a `KaeruWidget`.
  final kaeru = useKaeruContext();
  assert(kaeru != null, 'useContext must be called within a KaeruWidget');

  return kaeru!.context;
}
