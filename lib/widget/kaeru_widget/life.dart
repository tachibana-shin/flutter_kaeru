import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kaeru/kaeru.dart';


KaeruLifeMixin get _lifeContext {
  final ctx = useLifeContext();
  assert(ctx != null, 'Lifecycle must be used within a KaeruLifeMixin');

  return ctx!;
}

/// Registers a callback to be called when the widget is first mounted.
void onMounted(VoidCallback callback) => _lifeContext.onMounted(callback);
/// Registers a callback to be called when the widget's dependencies change.
void onDependenciesChanged(VoidCallback callback) =>
    _lifeContext.onDependenciesChanged(callback);
/// Registers a callback to be called when the widget is updated.
void onUpdated(void Function(StatefulWidget) callback) =>
    _lifeContext.onUpdated(callback);
/// Registers a callback to be called before the widget is unmounted.
void onBeforeUnmount(VoidCallback callback) =>
    _lifeContext.onBeforeUnmount(callback);
/// Registers a callback to be called when the widget is deactivated.
void onDeactivated(VoidCallback callback) =>
    _lifeContext.onDeactivated(callback);
/// Registers a callback to be called when the widget is activated.
void onActivated(VoidCallback callback) => _lifeContext.onActivated(callback);
/// Registers a callback to be called when the widget's properties are being filled for debugging.
void onDebugFillProperties(
        void Function(DiagnosticPropertiesBuilder properties) callback) =>
    _lifeContext.onDebugFillProperties(callback);
/// Registers a callback to be called before the widget is built.
void onBeforeBuild(void Function(BuildContext context) callback) =>
    _lifeContext.onBeforeBuild(callback);