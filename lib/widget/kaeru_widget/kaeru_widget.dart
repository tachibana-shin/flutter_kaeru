import 'package:flutter/material.dart';
import 'package:kaeru/kaeru.dart';

export 'composables/flutter.dart';
export 'composables/use_context.dart';
export 'composables/use_widget.dart';

export 'life.dart';
export 'reactive.dart';
export 'widget_advanced.dart';

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

KaeruLifeMixin? useLifeContext() {
  return _lifeContext;
}

class KaeruWidget<W extends Widget> extends StatefulWidget {
  @protected
  Setup setup() {
    throw UnimplementedError('setup must be implemented');
  }

  Computed<T> prop<T>(T Function(W w) compute) {
    assert(
        _kaeruContext != null, 'Reactivity must be used within a KaeruMixin');
    assert(_kaeruContext!.widget is W, 'The type $W must be of type widget');

    final ctx = _kaeruContext;
    final computer = computed(() => compute(ctx!.widget as W));
    onUpdated(computer.onChange);

    return computer;
  }

  const KaeruWidget({super.key});

  @override
  createState() => KaeruWidgetState();
}

class KaeruWidgetState extends State<KaeruWidget>
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
    return Watch(_setup);
  }
}
