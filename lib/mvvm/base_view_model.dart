import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:presentation_sample/effect.dart';

import 'closeable.dart';

abstract class BaseEffectViewModel<State, Effect> extends BaseViewModel<State> {
  final StreamController<OneTimeEffect<Effect>> _effectController = StreamController<OneTimeEffect<Effect>>();
  Stream<OneTimeEffect<Effect>> get effectSteam => _effectController.stream;

  void setEffect(Effect effect) {
    _effectController.sink.add(OneTimeEffect(effect));
  }

  @override
  FutureOr<void> close() async {
    await _effectController.close();
    super.close();
  }
}

abstract class BaseViewModel<State> implements Closeable {
  final StreamController<State> _stateController = StreamController<State>();
  Stream<State> get stateSteam => _stateController.stream;

  void setState(State state) {
    _stateController.sink.add(state);
  }

  @override
  bool get isClosed => _stateController.isClosed;

  @override
  @mustCallSuper
  FutureOr<void> close() {
    _stateController.close();
  }
}
