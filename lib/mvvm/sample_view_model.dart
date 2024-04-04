import 'dart:async';

import 'package:presentation_sample/mvvm/base_view_model.dart';
import 'package:presentation_sample/mvvm/sample_effect.dart';
import 'package:presentation_sample/sample_repository.dart';

class DataViewModel extends BaseEffectViewModel<String, SampleEffect> {
  final DataRepository _repository;
  // this is an example of using 2 different states in same ViewModel or Cubit etc. Should be in a separate viewmodel.
  final StreamController<int> _counterController = StreamController<int>();
  int _counter = 0;

  Stream<int> get counterStream => _counterController.stream;
  StreamSubscription<int>? _repoSteamSubscription;

  DataViewModel(this._repository) {
    _repoSteamSubscription = _repository.dataStream.listen((data) {
      setState('Processed: $data');
    });
    _repository.fetchData();
    _counterController.sink.add(_counter);
  }

  void counterAdd() {
    _counter++;
    _counterController.sink.add(_counter);
    setEffect(NewCount(_counter));
  }

  @override
  FutureOr<void> close() {
    _counterController.close();
    _repoSteamSubscription?.cancel();
  }
}
