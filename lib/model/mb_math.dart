num sum(num a, num b) {
  return a + b;
}

int combination(int n, int r) {
  if (r > n) {
    throw ArgumentError('r > n');
  }
  return factorial(n) ~/ (factorial(r) * factorial(n - r));
}

int factorial(int i) {
  if (i < 0) {
    throw ArgumentError('number should be positive', 'i');
  }
  final cache = [1, ...List.filled(i, 0)];
  for (var k = 1; k <= i; k++) {
    cache[k] = k * cache[k - 1];
  }
  return cache[i];
}
