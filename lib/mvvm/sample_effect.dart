sealed class SampleEffect {
  const SampleEffect();
}

class NewCount extends SampleEffect {
  final int count;

  NewCount(this.count);
}