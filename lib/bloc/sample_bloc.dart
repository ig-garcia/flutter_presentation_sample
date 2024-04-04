import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation_sample/bloc/data_event.dart';
import 'package:presentation_sample/cubit/data_state.dart';

import '../sample_repository.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final DataRepository _repository;
  final StreamController<int> _counterController = StreamController<int>();
  int _counter = 0;
  Stream<int> get counterStream => _counterController.stream;

  DataBloc(this._repository): super(const NoDataYet()) {
    on<ListenToData>(onListenToData);
    on<DataFromRepo>(onDataFromRepo);
    add(const ListenToData());
    _repository.fetchData();
    _counterController.sink.add(_counter);
  }

  Future<void> onListenToData(ListenToData event, Emitter<DataState> emit) async {
    await emit.onEach<int>(
      _repository.dataStream,
      onData: (value) => add(DataFromRepo(value)),
    );
  }

  Future<void> onDataFromRepo(DataFromRepo event, Emitter<DataState> emit) async {
    emit(GotData('Processed: ${event.data}'));
  }

  void counterAdd() {
    _counter ++;
    _counterController.sink.add(_counter);
  }


  @override
  Future<void> close() {
    _counterController.close();
    return super.close();
  }
}