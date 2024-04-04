import 'dart:async';

import 'package:presentation_sample/mvvm/base_view_model.dart';
import 'package:presentation_sample/sample_repository.dart';

class DataViewModel implements BaseViewModel {
  final DataRepository _repository;
  final StreamController<String> _processedDataController = StreamController<String>();
  final StreamController<int> _counterController = StreamController<int>();
  int _counter = 0;

  Stream<String> get processedDataStream => _processedDataController.stream;
  Stream<int> get counterStream => _counterController.stream;
  StreamSubscription<int>? _repoSteamSubscription;

  DataViewModel(this._repository) {
    _repoSteamSubscription = _repository.dataStream.listen((data) {
      // Process the incoming data and add it to the processedDataController
      // For example, convert the integer to a string with some prefix
      _processedDataController.sink.add('Processed: $data');
    });
    _repository.fetchData();
    _counterController.sink.add(_counter);
  }

  void counterAdd() {
    _counter ++;
    _counterController.sink.add(_counter);
  }

  @override
  FutureOr<void> close() {
    _processedDataController.close();
    _counterController.close();
    _repoSteamSubscription?.cancel();
  }

  @override
  bool get isClosed => _processedDataController.isClosed;
}
