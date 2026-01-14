import 'package:flutter/material.dart';
import 'package:kaeru/kaeru.dart';

export 'composables/use_request/use_request.dart';
export 'composables/flutter.dart';
export 'composables/use_context.dart';
export 'composables/use_dark.dart';
export 'composables/use_inherited.dart';
export 'composables/use_keep_alive_client.dart';
export 'composables/use_listen.dart';
export 'composables/use_model.dart';
export 'composables/use_media_query.dart';
export 'composables/use_restoration.dart';
export 'composables/use_single_ticker_state.dart';
export 'composables/use_stream.dart';
export 'composables/use_theme.dart';
export 'composables/use_widget.dart';
export 'composables/use_widget_box.dart';
export 'composables/use_widget_size.dart';

export 'life.dart';
export 'reactive.dart';

export 'kaeru_async_widget.dart';

/// A function that returns a widget.
typedef Setup = Widget Function();

KaeruMixin? _kaeruContext;
KaeruMixin? _setKaeruContext(KaeruMixin? context) {
  final old = _kaeruContext;
  _kaeruContext = context;
  return old;
}

void _restoreKaeruContext(KaeruMixin? old) {
  _kaeruContext = old;
}

/// Returns the current [KaeruMixin] instance.
KaeruMixin? useKaeruContext() {
  return _kaeruContext;
}

KaeruLifeMixin? _lifeContext;
KaeruLifeMixin? _setLifeContext(KaeruLifeMixin? context) {
  final old = _lifeContext;
  _lifeContext = context;
  return old;
}

void _restoreLifeContext(KaeruLifeMixin? old) {
  _lifeContext = old;
}

/// Returns the current [KaeruLifeMixin] instance.
KaeruLifeMixin? useLifeContext() {
  return _lifeContext;
}

/// A widget that provides a reactive context for its children.
abstract class KaeruWidget<W extends StatefulWidget> extends StatefulWidget {
  /// A function that returns a widget.
  @protected
  Setup setup();

  /// Creates a [Computed] that depends on the widget's properties.
  Computed<T> prop<T>(T Function(W w) compute) {
    final widget = useWidget<W>();

    return computed(() => compute(widget.value));
  }

  const KaeruWidget({super.key});

  @override
  createState() => KaeruWidgetState<W>();
}

/// The state for a [KaeruWidget].
class KaeruWidgetState<T extends StatefulWidget> extends State<KaeruWidget<T>>
    with KaeruMixin, KaeruLifeMixin {
  late final Setup _setup;

  @override
  void initState() {
    super.initState();

    final old = _setKaeruContext(this);
    final oldLife = _setLifeContext(this);
    _setup = widget.setup();
    _restoreKaeruContext(old);
    _restoreLifeContext(oldLife);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Watch(_setup);
  }
}
