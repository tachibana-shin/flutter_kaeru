// 1. TickerProvider
import 'package:flutter/material.dart';

import 'kaeru_widget.dart';

class KaeruTickerWidget<T> extends KaeruWidget<KaeruTickerWidget<T>> {
  const KaeruTickerWidget({super.key});

  @override
  createState() => _KaeruTickerWidgetState<T>();
}

class _KaeruTickerWidgetState<T> extends KaeruWidgetState
    with TickerProviderStateMixin {}

// 2. KeepAlive
class KaeruKeepAliveWidget<T> extends KaeruWidget<KaeruKeepAliveWidget<T>> {
  const KaeruKeepAliveWidget({super.key});

  @override
  createState() => _KaeruKeepAliveWidgetState<T>();
}

class _KaeruKeepAliveWidgetState<T> extends KaeruWidgetState
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
}

// 3. Restoration
class KaeruRestorationWidget<T> extends KaeruWidget<KaeruRestorationWidget<T>> {
  const KaeruRestorationWidget({super.key});

  @override
  createState() => _KaeruRestorationWidgetState<T>();
}

class _KaeruRestorationWidgetState<T> extends KaeruWidgetState
    with RestorationMixin {
  @override
  String? get restorationId => 'kaeru_restoration_${widget.key ?? ""}';
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {}
}

// 4. Lifecycle Observer
class KaeruLifecycleWidget<T> extends KaeruWidget<KaeruLifecycleWidget<T>> {
  const KaeruLifecycleWidget({super.key});

  @override
  createState() => _KaeruLifecycleWidgetState<T>();
}

class _KaeruLifecycleWidgetState<T> extends KaeruWidgetState
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

// 5. All
class KaeruTickerKeepAliveWidget<T>
    extends KaeruWidget<KaeruTickerKeepAliveWidget<T>> {
  const KaeruTickerKeepAliveWidget({super.key});

  @override
  createState() => _KaeruTickerKeepAliveWidgetState<T>();
}

class _KaeruTickerKeepAliveWidgetState<T> extends KaeruWidgetState
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
}
