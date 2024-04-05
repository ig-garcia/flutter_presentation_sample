import 'dart:async';

abstract class Closeable {
  /// Closes the current instance.
  /// The returned future completes when the instance has been closed.
  FutureOr<void> close();
}
