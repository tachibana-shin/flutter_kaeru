import 'controller.dart';
import 'options.dart';

export 'controller.dart';
export 'options.dart';

/// Represents the result of a paginated request.
class PaginationResult<T> {
  /// The items for the current page.
  final List<T> items;

  /// The total number of items across all pages.
  final int total;

  PaginationResult(this.items, this.total);
}

/// A composable for managing paginated data fetching.
///
/// It simplifies the process of handling loading states, errors, and pagination logic.
///
/// ## Example
///
/// ```dart
/// // In your widget
/// final controller = usePagination((page, pageSize) => fetchUsers(page, pageSize));
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
/// return ListView.builder(
///   itemCount: controller.items.length,
///   itemBuilder: (context, index) {
///     final user = controller.items[index];
///     return ListTile(title: Text(user.name));
///   },
/// );
/// ```
///
/// [service] is the asynchronous function that fetches the data for a given page and page size.
/// [options] are the options for the pagination request.
PaginationController<T> usePagination<T>(
  Future<PaginationResult<T>> Function(int page, int pageSize) service, {
  PaginationOptions<T> options = const PaginationOptions(),
}) {
  return PaginationController(service, options);
}
