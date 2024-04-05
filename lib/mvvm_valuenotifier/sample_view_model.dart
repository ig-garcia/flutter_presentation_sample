import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:presentation_sample/mvvm_valuenotifier/base_view_model.dart';
import 'package:presentation_sample/mvvm_valuenotifier/sample_effect.dart';
import 'package:presentation_sample/sample_repository.dart';

class DataViewModel extends BaseEffectViewModel<String, SampleEffect> {
  final DataRepository _repository;
  // this is an example of using 2 different states in same ViewModel or Cubit etc. Should be in a separate viewmodel.
  final ValueNotifier<int> counterValueNotifier = ValueNotifier(0);
  int get counter => counterValueNotifier.value;

  StreamSubscription<int>? _repoSteamSubscription;

  DataViewModel(this._repository): super("", const IdleEffect()) {
    _repoSteamSubscription = _repository.dataStream.listen((data) {
      setState('Processed: $data');
    });
    _repository.fetchData();
  }

  void counterAdd() {
    counterValueNotifier.value++;
    setEffect(NewCount(counter));
  }

  @override
  FutureOr<void> close() async {
    counterValueNotifier.dispose();
    await _repoSteamSubscription?.cancel();
    super.close();
  }
}
