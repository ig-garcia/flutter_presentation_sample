sealed class SampleEffect {
  const SampleEffect();
}

class IdleEffect extends SampleEffect {
  const IdleEffect();
}

class NewCount extends SampleEffect {
  final int count;

  NewCount(this.count);
}