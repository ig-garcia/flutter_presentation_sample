import 'dart:async';
import 'dart:math';

class DataRepository {
  final StreamController<int> _dataController = StreamController<int>();

  Stream<int> get dataStream => _dataController.stream;

  void fetchData() {
    // Simulate database updates with a periodic timer
    Timer.periodic(Duration(seconds: 1), (timer) {
      _dataController.sink.add(Random().nextInt(100));  // Random data for example
    });
  }

  void dispose() {
    _dataController.close();
  }
}
