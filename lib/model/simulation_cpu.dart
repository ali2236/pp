class Cpu {
  final int id;
  final int iterations;
  var blocked = false;
  var pc = 0;
  var memoryAccesses = 0;
  var effectiveAccesses = 0;
  Cpu(this.id, this.iterations);

  double get BWeffective => effectiveAccesses / memoryAccesses;

  int get clksRan => pc;
  int get clksBlocked => iterations - pc;

  double get percentRan => clksRan / iterations;
  double get percentBlocked => clksBlocked / iterations;

  @override
  String toString() {
    return '(CPU_$id, pc=$pc, BWe=$BWeffective)';
  }
}