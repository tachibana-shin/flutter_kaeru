import '../../../../../foundation/ref.dart';
import '../../../reactive.dart';
import 'pagination.dart';

/// Manages the state and lifecycle of a paginated request.
///
/// This controller handles the data, loading, error, and pagination states,
/// as well as provides methods to change pages and refresh the data.
class PaginationController<T> {
  /// The asynchronous function that fetches the data for a given page and page size.
  final Future<PaginationResult<T>> Function(int page, int pageSize) service;

  /// The options for the pagination request.
  final PaginationOptions<T> options;

  /// The fetched data for the current page. It is a [Ref].
  final Ref<List<T>> data = ref([]);

  /// The total number of items across all pages. It is a [Ref].
  final Ref<int> total = ref(0);

  /// The current page number. It is a [Ref].
  final Ref<int> page;

  /// The number of items per page. It is a [Ref].
  final Ref<int> pageSize;

  /// The loading state of the request. It is a [Ref].
  final Ref<bool> loading = ref(false);

  /// The error object if the request fails. It is a [Ref].
  final Ref<Object?> error = ref(null);

  PaginationController(this.service, this.options)
      : page = ref(1),
        pageSize = ref(options.defaultPageSize) {
    run();
  }

  /// Executes the request for the current page and page size.
  Future<void> run() async {
    loading.value = true;
    try {
      final result = await service(page.value, pageSize.value);
      data.value = result.items;
      total.value = result.total;
    } catch (e) {
      error.value = e;
    } finally {
      loading.value = false;
    }
  }

  /// Changes the current page and re-runs the request.
  void changePage(int newPage) {
    page.value = newPage;
    run();
  }

  /// Changes the page size, resets the page to 1, and re-runs the request.
  void changePageSize(int newSize) {
    pageSize.value = newSize;
    page.value = 1;
    run();
  }

  /// Re-runs the request for the current page. Alias for [run].
  void refresh() => run();
}
