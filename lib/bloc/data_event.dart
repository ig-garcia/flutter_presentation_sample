sealed class DataEvent {
  const DataEvent();
}

class ListenToData extends DataEvent {
  const ListenToData();
}

class DataFromRepo extends DataEvent {
  final int data;
  const DataFromRepo(this.data);
}
