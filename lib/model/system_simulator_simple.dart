import 'dart:math';

class Cpu {
  final int id;
  var blocked = false;
  var pc = 0;
  var memoryAccesses = 0;
  var effectiveAccesses = 0;
  Cpu(this.id);

  double get BWeffective => effectiveAccesses / memoryAccesses;

  @override
  String toString() {
    return '(CPU_$id, pc=$pc, BWe=$BWeffective)';
  }
}

class MemoryRequest{
  final int time;
  final Cpu cpu;
  final int memory;

  MemoryRequest(this.time, this.cpu, this.memory);
}

void main() {
  // input
  const N = 66;
  const M = 28;
  const B = 10;
  const Pm = 0.04;
  const iterations = 1e4;

  // simulation entities
  final cpus = List.generate(N, (i) => Cpu(i));
  final random = Random();
  bool randomMemoryAccess() => random.nextDouble() <= Pm;
  int randomMemory() => random.nextInt(M);
  final reqs = <MemoryRequest>[];

  // simulation
  for (var t = 0; t < iterations; t++) {

    // run cpus for 1 clk
    for (var cpu in cpus) {
      if(cpu.blocked) continue;
      if(randomMemoryAccess()){
        final mem = randomMemory();
        final req = MemoryRequest(t, cpu, mem);
        reqs.add(req);
        cpu.memoryAccesses++;
        cpu.blocked = true;
        continue;
      }
      cpu.pc++;
    }

    // run arbiter(fcfs)
    if(reqs.isNotEmpty) {
      int b = 0;
      for(var m=0;m<M && b<B;m++){
        final i = reqs.indexWhere((req) => req.memory == m);
        if(i==-1) continue;
        final req = reqs.removeAt(i);
        final cpu = req.cpu;
        if(req.time == t){
          cpu.effectiveAccesses++;
        }
        cpu.blocked = false;
        cpu.pc++;
        b++;
      }
    }

    // run arbiter()
  }

  print(cpus.map((c) => c.BWeffective).reduce((a, b) => a + b) / N);
  print(cpus);
}
