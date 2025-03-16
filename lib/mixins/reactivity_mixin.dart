import 'package:flutter/widgets.dart';

import '../foundation/computed.dart';
import '../foundation/ref.dart';

mixin ReactivityMixin<T extends StatefulWidget> on State<T> {
  Ref<U> ref<U>(U value) => Ref(value);
  Computed<U> computed<U>(U Function() getter) => Computed(getter);
}
