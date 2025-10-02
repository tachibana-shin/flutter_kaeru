/// Options for configuring the behavior of [usePagination].
class PaginationOptions<T> {
  /// The default page size to use.
  final int defaultPageSize;

  /// The key to use for caching the data.
  final String? cacheKey;

  const PaginationOptions({
    this.defaultPageSize = 20,
    this.cacheKey,
  });
}
