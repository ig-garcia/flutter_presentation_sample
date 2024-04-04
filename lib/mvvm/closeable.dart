import 'dart:async';

abstract class Closeable {
  /// Closes the current instance.
  /// The returned future completes when the instance has been closed.
  FutureOr<void> close();

  /// Whether the object is closed.
  ///
  /// An object is considered closed once [close] is called.
  bool get isClosed;
}
