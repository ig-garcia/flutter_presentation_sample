sealed class DataState {
  const DataState();
}

class NoDataYet extends DataState {
  const NoDataYet();
}

class GotData extends DataState {
  final String data;

  GotData(this.data);
}