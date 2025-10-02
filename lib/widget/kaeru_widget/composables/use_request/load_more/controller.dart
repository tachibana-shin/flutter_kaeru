import '../../../../../foundation/ref.dart';
import '../../../reactive.dart';

/// Manages the state and lifecycle of a "load more" request.
///
/// This controller handles the data, loading, error, and pagination states,
/// as well as provides a method to load more data.
class LoadMoreController<T> {
  /// The asynchronous function that fetches the data for a given page and the last item.
  final Future<List<T>> Function(int page, T? lastItem) service;

  /// The fetched data. It is a [Ref] that accumulates items from all pages.
  final Ref<List<T>> data = ref([]);

  /// The current page number. It is a [Ref].
  final Ref<int> page = ref(1);

  /// The loading state of the request. It is a [Ref].
  final Ref<bool> loading = ref(false);

  /// The error object if the request fails. It is a [Ref].
  final Ref<Object?> error = ref(null);

  LoadMoreController(this.service);

  /// Fetches the next page of data and appends it to the [data] list.
  Future<void> loadMore() async {
    loading.value = true;
    try {
      final last = data.value.isEmpty ? null : data.value.last;
      final newItems = await service(page.value, last);
      data.value = [...data.value, ...newItems];
      page.value++;
    } catch (e) {
      error.value = e;
    } finally {
      loading.value = false;
    }
  }
}
