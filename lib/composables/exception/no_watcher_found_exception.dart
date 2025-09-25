/// An exception that is thrown when a reactive function is called outside of a
/// reactive context.
class NoWatcherFoundException implements Exception {
  final String? message;

  NoWatcherFoundException([this.message]);
}