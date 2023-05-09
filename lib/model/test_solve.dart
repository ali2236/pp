import 'dart:math';

void main() {
  final int speedup = 40;

  final double BWeffective = 0.92; // effective access
  final double fs = 0.01; // serial percentage
  final double fp = (1 - fs); // parallel percentage

  // use amdhals law to find N
  // 1/speedup = fs + fp/N
  // fp/N = fs - (1/speedup)
  // fp/N = fs - (1/speedup)
  // N = (fs - (1/speedup))/fp
  final N = ((speedup * fp) / (1 - (speedup * fs))).round();

  final double Pm = 4 / 100; // avg access time

  // for B >= M
  // BWeffective = M(1-(1-(Pm/M)^N))
  // for B < M
  // p1 = 1 - (1 - Pm/M)^N
  // Pa(i) = (m,i) p1^i - (1 - p1)^(M-i)
  // BWeffective = for i=1..B: i*Pa(i) + for i=B+1..M: B*Pa(i)

  const max = 50;
  final bw = List.generate(max, (i) => List<num>.generate(max, (j) => 0.0));
  for (var B = 1; B < max; B++) {
    for (var M = 1; M < max; M++) {
      if (B >= M) {
        final t1 = pow(1 - (Pm / M), N);
        final it1 = (1 - t1);
        bw[B][M] = M * it1;
      } else {
        continue;
        final p1 = 1 - pow(1 - Pm / M, N);
        num Pa(int i) => combination(M, i) * pow(p1, i) * pow(1 - p1, M - i);
        bw[B][M] =
            List.generate(B, (i) => i + 1).map((i) => i * Pa(i)).reduce(sum) +
                List.generate(M - B + 1, (i) => i + B + 1)
                    .map((i) => B * Pa(i))
                    .reduce(sum);
      }
    }
  }

  printMatrix(bw);
}

void printMatrix<T>(List<List<T>> matrix) {
  final buffer = StringBuffer();
  for (var row in matrix) {
    for (var datum in row) {
      buffer.write('$datum\t');
    }
    buffer.write('\n');
  }
  print(buffer);
}

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
