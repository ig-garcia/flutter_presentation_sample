import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation_sample/cubit/data_state.dart';

import '../sample_repository.dart';

class DataCubit extends Cubit<DataState> {
  final DataRepository _repository;
  StreamSubscription<int>? _repoSteamSubscription;
  final StreamController<int> _counterController = StreamController<int>();
  int _counter = 0;
  Stream<int> get counterStream => _counterController.stream;

  DataCubit(this._repository): super(const NoDataYet()) {
    _repoSteamSubscription = _repository.dataStream.listen((data) {
      // Process the incoming data and add it to the processedDataController
      // For example, convert the integer to a string with some prefix
      emit(GotData('Processed: $data'));
    });
    _repository.fetchData();
    _counterController.sink.add(_counter);
  }

  void counterAdd() {
    _counter ++;
    _counterController.sink.add(_counter);
  }


  @override
  Future<void> close() {
    _repoSteamSubscription?.cancel();
    _counterController.close();
    return super.close();
  }
}