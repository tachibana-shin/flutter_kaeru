import 'package:flutter/widgets.dart';

/// `KaeruLifeMixin` provides Vue-like lifecycle hooks for StatefulWidgets.
///
/// ✅ **Available lifecycle hooks:**
/// - `onMounted()`: Called when the widget is initialized (`initState`).
/// - `onDependenciesChanged()`: Called when widget dependencies change (`didChangeDependencies`).
/// - `onUpdated()`: Called when the parent widget updates properties (`didUpdateWidget`).
/// - `onDeactivated()`: Called when the widget is temporarily removed from the tree (`deactivate`).
/// - `onBeforeUnmount()`: Called before the widget is permanently removed (`dispose`).
///
/// 🎯 **Benefits:**
/// - Supports multiple callbacks for each lifecycle event.
/// - Provides a cleaner and more intuitive way to handle widget lifecycles.
/// - Eliminates the need to override multiple lifecycle methods in each `StatefulWidget`.
mixin KaeruLifeMixin<T extends StatefulWidget> on State<T> {
  /// Callbacks triggered when the widget is mounted (`initState`).
  final _fnMounted = <VoidCallback>{};

  /// Callbacks triggered when dependencies change (`didChangeDependencies`).
  final _fnDependenciesChanged = <VoidCallback>{};

  /// Callbacks triggered when the widget is updated (`didUpdateWidget`).
  final _fnUpdated = <VoidCallback>{};

  /// Callbacks triggered before the widget is disposed (`dispose`).
  final _fnBeforeUnmount = <VoidCallback>{};

  /// Callbacks triggered when the widget is activated (`activate`).
  final _fnActivated = <VoidCallback>{};

  /// Callbacks triggered when the widget is temporarily removed (`deactivate`).
  final _fnDeactivated = <VoidCallback>{};

  /// Registers a callback to be called when the widget is first mounted (`initState`).
  void onMounted(VoidCallback callback) {
    _fnMounted.add(callback);
  }

  /// Registers a callback to be called when dependencies change (`didChangeDependencies`).
  void onDependenciesChanged(VoidCallback callback) {
    _fnDependenciesChanged.add(callback);
  }

  /// Registers a callback to be called when the widget updates (`didUpdateWidget`).
  void onUpdated(VoidCallback callback) {
    _fnUpdated.add(callback);
  }

  /// Registers a callback to be called before the widget is disposed (`dispose`).
  void onBeforeUnmount(VoidCallback callback) {
    _fnBeforeUnmount.add(callback);
  }

  /// Registers a callback to be called when the widget is activated (`activate`).
  void onActivated(VoidCallback callback) {
    _fnActivated.add(callback);
  }

  /// Registers a callback to be called when the widget is temporarily removed (`deactivate`).
  void onDeactivated(VoidCallback callback) {
    _fnDeactivated.add(callback);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      for (var fn in _fnMounted) {
        fn();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var fn in _fnDependenciesChanged) {
      fn();
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (var fn in _fnUpdated) {
      fn();
    }
  }

  @override
  void activate() {
    for (var fn in _fnActivated) {
      fn();
    }
    super.activate();
  }

  @override
  void deactivate() {
    for (var fn in _fnDeactivated) {
      fn();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    for (var fn in _fnBeforeUnmount) {
      fn();
    }
    super.dispose();
  }
}
