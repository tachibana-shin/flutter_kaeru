import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kaeru/kaeru.dart';

import 'kaeru_widget.dart';

KaeruLifeMixin get _lifeContext {
  final ctx = useLifeContext();
  assert(ctx != null, 'Lifecycle must be used within a KaeruLifeMixin');

  return ctx!;
}

void onMounted(VoidCallback callback) => _lifeContext.onMounted(callback);
void onDependenciesChanged(VoidCallback callback) =>
    _lifeContext.onDependenciesChanged(callback);
void onUpdated(void Function(StatefulWidget) callback) =>
    _lifeContext.onUpdated(callback);
void onBeforeUnmount(VoidCallback callback) =>
    _lifeContext.onBeforeUnmount(callback);
void onDeactivated(VoidCallback callback) =>
    _lifeContext.onDeactivated(callback);
void onActivated(VoidCallback callback) => _lifeContext.onActivated(callback);
void onDebugFillProperties(
        void Function(DiagnosticPropertiesBuilder properties) callback) =>
    _lifeContext.onDebugFillProperties(callback);
void onBeforeBuild(void Function(BuildContext context) callback) =>
    _lifeContext.onBeforeBuild(callback);
