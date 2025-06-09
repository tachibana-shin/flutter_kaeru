import 'package:flutter/material.dart';

import 'use_state.dart';

BuildContext useContext() {
  return useState().context;
}
