import 'package:flutter/widgets.dart';

import 'package:kaeru/mixins/kaeru_life_mixin.dart';
import 'package:kaeru/widget/kaeru_widget/life.dart';

import 'use_context.dart';

/// A hook that provides restoration capabilities for widgets.
///
/// This hook allows you to manage the restoration of state across
/// app restarts and other lifecycle events. It integrates with the
/// [RestorationMixin] to enable automatic restoration of properties
/// that need to be preserved.
///
/// Example:
/// ```dart
/// final restoration = useRestoration(
///   restorationId: 'my_widget',
///   restoreState: (oldBucket, initialRestore) {
///     // Restore your state here
///   },
///   didToggleBucket: (oldBucket) {
///     // Handle bucket toggling here
///   },
/// );
/// ```
RestorationMixin useRestoration({
  /// An optional identifier for the restoration bucket. This ID is used to
  /// associate the restoration state with the corresponding widget.
  String? restorationId,
  required void Function(RestorationBucket? oldBucket, bool initialRestore)
      restoreState,
  required void Function(RestorationBucket? oldBucket) didToggleBucket,
  void Function(RestorableProperty<Object?> property, String restorationId)?
      registerForRestoration,
  void Function(RestorableProperty<Object?> property)?
      unregisterFromRestoration,
  VoidCallback? didUpdateRestorationId,
}) {
  final context = useContext();
  final restoration = _Restoration(context,
      restorationId: restorationId,
      restoreState: restoreState,
      didToggleBucket: didToggleBucket,
      registerForRestoration: registerForRestoration,
      unregisterFromRestoration: unregisterFromRestoration,
      didUpdateRestorationId: didUpdateRestorationId);

  onUpdated(restoration.didUpdateWidget);
  onDependenciesChanged(restoration.didChangeDependencies);
  onBeforeUnmount(restoration.dispose);

  return restoration;
}

class _Restoration extends State<StatefulWidget> with RestorationMixin {
  late final BuildContext _contextOutside;
  late final String? _restorationId;

  late final void Function(RestorationBucket? oldBucket, bool initialRestore)
      _restoreState;
  late final void Function(RestorationBucket? oldBucket) _didToggleBucket;
  late final void Function(
          RestorableProperty<Object?> property, String restorationId)?
      _registerForRestoration;
  late final void Function(RestorableProperty<Object?> property)?
      _unregisterFromRestoration;
  late final VoidCallback? _didUpdateRestorationId;

  _Restoration(BuildContext context,
      {String? restorationId,
      required void Function(RestorationBucket? oldBucket, bool initialRestore)
          restoreState,
      required void Function(RestorationBucket? oldBucket) didToggleBucket,
      void Function(RestorableProperty<Object?> property, String restorationId)?
          registerForRestoration,
      void Function(RestorableProperty<Object?> property)?
          unregisterFromRestoration,
      VoidCallback? didUpdateRestorationId}) {
    _contextOutside = context;
    _restorationId = restorationId;
    _restoreState = restoreState;
    _didToggleBucket = didToggleBucket;
    _registerForRestoration = registerForRestoration;
    _unregisterFromRestoration = unregisterFromRestoration;
    _didUpdateRestorationId = didUpdateRestorationId;
  }

  @override
  get context => _contextOutside;
  @override
  get restorationId => _restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _restoreState(oldBucket, initialRestore);
  }

  @override
  void didToggleBucket(RestorationBucket? oldBucket) {
    super.didToggleBucket(oldBucket);
    _didToggleBucket(oldBucket);
  }

  @override
  void registerForRestoration(
      RestorableProperty<Object?> property, String restorationId) {
    super.registerForRestoration(property, restorationId);
    _registerForRestoration?.call(property, restorationId);
  }

  @override
  void unregisterFromRestoration(RestorableProperty<Object?> property) {
    super.unregisterFromRestoration(property);
    _unregisterFromRestoration?.call(property);
  }

  @override
  void didUpdateRestorationId() {
    super.didUpdateRestorationId();
    _didUpdateRestorationId?.call();
  }

  @override
  Widget build(_) => const NullWidget();
}