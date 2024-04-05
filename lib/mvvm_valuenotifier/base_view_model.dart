import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:presentation_sample/effect.dart';
import 'package:presentation_sample/mvvm_valuenotifier/closeable.dart';

abstract class BaseEffectViewModel<State, Effect> extends BaseViewModel<State> {
  late final ValueNotifier<OneTimeEffect<Effect>> effectValueNotifier;

  BaseEffectViewModel(super.initialState, Effect initialEffect) {
    effectValueNotifier = ValueNotifier(OneTimeEffect(initialEffect));
  }

  void setEffect(Effect effect) {
    effectValueNotifier.value = OneTimeEffect(effect);
  }

  @override
  FutureOr<void> close() async {
    effectValueNotifier.dispose();
    super.close();
  }
}

abstract class BaseViewModel<State> implements Closeable {
  late final ValueNotifier<State> stateValueNotifier;


  BaseViewModel(State initialState) {
    this.stateValueNotifier = ValueNotifier(initialState);
  }

  void setState(State state) {
    stateValueNotifier.value = state;
  }

  @override
  @mustCallSuper
  FutureOr<void> close() {
    stateValueNotifier.dispose();
  }
}
