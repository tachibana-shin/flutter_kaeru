import 'dart:async';

import 'controller.dart';
import 'options.dart';

export 'controller.dart';
export 'options.dart';

/// A composable for managing asynchronous data fetching.
///
/// It simplifies the process of handling loading states, errors, and data fetching logic.
/// It is inspired by VueUse's `useRequest`.
///
/// ## Example
///
/// ```dart
/// // In your widget
/// final controller = useRequest(() => fetchUserData());
///
/// // In your build method
/// if (controller.loading.value) {
///   return CircularProgressIndicator();
/// }
///
/// if (controller.error.value != null) {
///   return Text('Error: ${controller.error.value}');
/// }
///
/// return Text('User: ${controller.data.value}');
/// ```
///
/// [service] is the asynchronous function that fetches the data.
/// [options] are the options for the request, such as manual triggering.
RequestController<T> useRequest<T>(
  Future<T> Function() service, {
  RequestOptions<T> options = const RequestOptions(),
}) {
  return RequestController(service, options);
}
