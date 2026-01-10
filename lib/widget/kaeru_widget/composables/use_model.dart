import 'package:flutter/widgets.dart';
import 'package:kaeru/foundation/ref.dart';
import 'package:kaeru/widget/kaeru_widget/composables/use_listen.dart';
import 'package:kaeru/widget/kaeru_widget/reactive.dart';

import 'flutter.dart';

class Model {
  final TextEditingController controller;
  final Ref<String> ref;

  const Model({required this.controller, required this.ref});
}

Model useModel([String? text]) {
  final controller = useTextEditingController(text);
  final value = ref<String>(text ?? "");

  useListen(controller, () => value.value = controller.text);
  useListen(value, () {
    if (value.value != controller.text) controller.text = value.value;
  });

  return Model(controller: controller, ref: value);
}
