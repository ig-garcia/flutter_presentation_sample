class OneTimeEffect<T> {
  final T content;
  bool _hasBeenHandled = false;

  OneTimeEffect(this.content);

  T? getContentIfNotHandled() {
    if (_hasBeenHandled) {
      return null;
    } else {
      _hasBeenHandled = true;
      return content;
    }
  }

  T peekContent() => content;
}