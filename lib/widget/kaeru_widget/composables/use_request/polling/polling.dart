import '../request/request.dart';

/// A composable for managing polling requests.
///
/// It repeatedly calls the service function at a specified interval.
///
/// ## Example
///
/// ```dart
/// // In your widget
/// final controller = usePolling(() => fetchNotifications(), interval: Duration(seconds: 10));
///
/// // In your build method
/// if (controller.loading.value && controller.data.value == null) {
///   return CircularProgressIndicator();
/// }
///
/// return Text('Notifications: ${controller.data.value}');
/// ```
///
/// [service] is the asynchronous function that fetches the data.
/// [interval] is the interval at which to poll the service.
RequestController<T> usePolling<T>(
  Future<T> Function() service, {
  Duration interval = const Duration(seconds: 5),
}) {
  return useRequest(
    service,
    options: RequestOptions(
      pollingInterval: interval,
    ),
  );
}
