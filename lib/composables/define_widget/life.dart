import 'package:flutter/widgets.dart';
import 'package:kaeru/kaeru.dart';

KaeruLifeMixin _getLife() {
  final ctx = getCurrentState();
  if (ctx == null) throw Exception('Current context is null');

  return ctx;
}

void $onMounted(VoidCallback callback) {
  _getLife().onMounted(callback);
}

void $onDependenciesChanged(VoidCallback callback) {
  _getLife().onDependenciesChanged(callback);
}

void $onUpdated(VoidCallback callback) {
  _getLife().onUpdated(callback);
}

void $onBeforeUnmount(VoidCallback callback) {
  _getLife().onBeforeUnmount(callback);
}

void $onDeactivated(VoidCallback callback) {
  _getLife().onDeactivated(callback);
}
