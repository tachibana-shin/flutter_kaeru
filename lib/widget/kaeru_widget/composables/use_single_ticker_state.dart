import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../life.dart';
import 'use_context.dart';

class _SingleTickerState implements TickerProvider {
  BuildContext context;
  Ticker? _ticker;

  _SingleTickerState(this.context);

  @override
  Ticker createTicker(TickerCallback onTick) {
    assert(() {
      if (_ticker == null) {
        return true;
      }
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary(
          '$runtimeType is a SingleTickerProviderStateMixin but multiple tickers were created.',
        ),
        ErrorDescription(
          'A SingleTickerProviderStateMixin can only be used as a TickerProvider once.',
        ),
        ErrorHint(
          'If a State is used for multiple AnimationController objects, or if it is passed to other '
          'objects and those objects might use it more than one time in total, then instead of '
          'mixing in a SingleTickerProviderStateMixin, use a regular TickerProviderStateMixin.',
        ),
      ]);
    }());
    _ticker = Ticker(
      onTick,
      debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null,
    );
    _updateTickerModeNotifier();
    _updateTicker(); // Sets _ticker.mute correctly.
    return _ticker!;
  }

  void dispose() {
    assert(() {
      if (_ticker == null || !_ticker!.isActive) {
        return true;
      }
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$this was disposed with an active Ticker.'),
        ErrorDescription(
          '$runtimeType created a Ticker via its SingleTickerProviderStateMixin, but at the time '
          'dispose() was called on the mixin, that Ticker was still active. The Ticker must '
          'be disposed before calling super.dispose().',
        ),
        ErrorHint(
          'Tickers used by AnimationControllers '
          'should be disposed by calling dispose() on the AnimationController itself. '
          'Otherwise, the ticker will leak.',
        ),
        _ticker!.describeForError('The offending ticker was'),
      ]);
    }());
    _tickerModeNotifier?.removeListener(_updateTicker);
    _tickerModeNotifier = null;
  }

  ValueListenable<bool>? _tickerModeNotifier;

  void activate() {
    _updateTickerModeNotifier();
    _updateTicker();
  }

  void _updateTicker() => _ticker?.muted = !_tickerModeNotifier!.value;

  void _updateTickerModeNotifier() {
    final ValueListenable<bool> newNotifier = TickerMode.getNotifier(context);
    if (newNotifier == _tickerModeNotifier) {
      return;
    }
    _tickerModeNotifier?.removeListener(_updateTicker);
    newNotifier.addListener(_updateTicker);
    _tickerModeNotifier = newNotifier;
  }

  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    final String? tickerDescription =
        switch ((_ticker?.isActive, _ticker?.muted)) {
      (true, true) => 'active but muted',
      (true, _) => 'active',
      (false, true) => 'inactive and muted',
      (false, _) => 'inactive',
      (null, _) => null,
    };
    properties.add(
      DiagnosticsProperty<Ticker>(
        'ticker',
        _ticker,
        description: tickerDescription,
        showSeparator: false,
        defaultValue: null,
      ),
    );
  }
}

/// Provides a hook to create a single ticker state for animations.
///
/// This hook returns a [TickerProvider] that can be used with
/// [AnimationController] and other animation-related classes.
///
/// Example:
/// ```dart
/// final tickerProvider = useSingleTickerState();
/// final animationController = AnimationController(
///   vsync: tickerProvider,
///   duration: const Duration(seconds: 1),
/// );
/// ```
TickerProvider useSingleTickerState() {
  final context = useContext();
  final ticker = _SingleTickerState(context);

  onActivated(ticker.activate);
  onBeforeUnmount(ticker.dispose);
  onDebugFillProperties(ticker.debugFillProperties);

  return ticker;
}