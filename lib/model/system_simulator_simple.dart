import 'dart:math';

import 'package:pp/model/simulation_cpu.dart';
import 'package:pp/model/simulation_params.dart';
import 'package:pp/model/simulation_result.dart';

class MemoryRequest{
  final int time;
  final Cpu cpu;
  final int memory;

  MemoryRequest(this.time, this.cpu, this.memory);
}

SimulationResult simulateMultiBus(SimulationParams params) {
  // input
  final N = params.N;
  final M = params.M;
  final B = params.B;
  final Pm = params.Pm;
  final iterations = 1e4.toInt();

  // simulation entities
  final cpus = List.generate(N, (i) => Cpu(i, iterations));
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

  return SimulationResult(
    cpus: cpus,
  );
}
