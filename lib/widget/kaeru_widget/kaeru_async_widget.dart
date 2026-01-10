import 'package:flutter/widgets.dart';
import 'package:kaeru/widget/kaeru_widget/kaeru_widget.dart';

typedef SetupAsync = Future<Setup>;

abstract class KaeruAsyncWidget extends KaeruWidget {
  static Widget Function() defaultLoading = () => const SizedBox.shrink();
  static Widget Function(Object?) defaultError = (error) =>
      Text("$error", style: const TextStyle(color: Color(0xffff3b30)));
  static Widget Function() defaultEmpty = () =>
      Text("Empty value", style: const TextStyle(color: Color(0xffff3b30)));

  const KaeruAsyncWidget({super.key});

  @protected
  SetupAsync setupAsync();

  @protected
  Widget none() => const SizedBox.shrink();

  @protected
  Widget loading() => defaultLoading();

  @protected
  Widget error(Object? error) => defaultError(error);

  @protected
  Widget empty() => defaultEmpty();

  @override
  Setup setup() {
    final future = setupAsync();

    return () => FutureBuilder(
      future: future,
      builder: (_, snapshot) => switch (snapshot.connectionState) {
        .none => none(),
        .waiting => loading(),
        .active || .done => switch (snapshot.hasError) {
          true => error(snapshot.error),
          false => snapshot.requireData(),
        },
      },
    );
  }
}
