import 'package:flutter/material.dart';

import 'use_context.dart';

T useWidget<T extends Widget>() {
  final context = useContext();

  assert(context.widget is T, 'The type $T must be of type widget');

  return context.widget as T;
}
