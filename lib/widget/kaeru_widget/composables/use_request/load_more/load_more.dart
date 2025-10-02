import 'controller.dart';

export 'controller.dart';

/// A composable for managing "load more" or infinite scrolling data fetching.
///
/// It simplifies the process of handling loading states, errors, and appending new data.
///
/// ## Example
///
/// ```dart
/// // In your widget
/// final controller = useLoadMore((page, lastItem) => fetchPosts(page));
///
/// // In your build method
/// return ListView.builder(
///   itemCount: controller.items.length + 1,
///   itemBuilder: (context, index) {
///     if (index == controller.items.length) {
///       if (controller.loading.value) {
///         return CircularProgressIndicator();
///       } else if (controller.hasMore.value) {
///         return TextButton(onPressed: controller.loadMore, child: Text('Load More'));
///       } else {
///         return SizedBox.shrink();
///       }
///     }
///     final post = controller.items[index];
///     return ListTile(title: Text(post.title));
///   },
/// );
/// ```
///
/// [service] is the asynchronous function that fetches the data for a given page and the last item.
LoadMoreController<T> useLoadMore<T>(
  Future<List<T>> Function(int page, T? lastItem) service,
) {
  return LoadMoreController(service);
}
