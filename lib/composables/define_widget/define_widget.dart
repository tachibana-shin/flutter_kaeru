import 'package:flutter/material.dart';
import 'package:kaeru/kaeru.dart';
import 'main.dart';

import 'widget/define_widget_builder.dart';

// typedef WidgetBuilderWithArgs<T> = Widget Function(T args);

/// Defines a widget with a setup function that returns a render function.
///
/// **Note:** This is part of the deprecated `defineWidget` API.
@Deprecated('Use KaeruWidget instead. This will be removed in a future version.')
Widget Function(T args) defineWidget<T>(FunctionRender Function(T args) builder,
    {List<dynamic>? dependencies}) {
  return (args, {Key? key}) {
    return DefineWidgetBuilder(
      key: key,
      dependencies: dependencies,
      initState: (state) {
        final old = setCurrentState(state);

        final render = builder(args);

        restoreCurrentState(old);

        return render;
      },
      build: (context, render) {
        return Watch(dependencies: dependencies, () => render(context));
      },
    );
  };
}