import 'package:flutter/material.dart';
import 'package:kaeru/widget/kaeru_widget/kaeru_widget.dart';

BuildContext useContext() {
  final kaeru = useKaeruContext();
  assert(kaeru != null, 'useContext must be called within a KaeruWidget');
  
  return kaeru!.context;
}
