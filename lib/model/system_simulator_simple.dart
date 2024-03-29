import 'dart:math';
import 'package:pp/model/simulation_cpu.dart';
import 'package:pp/model/simulation_input.dart';
import 'package:pp/model/simulation_request.dart';
import 'package:pp/model/simulation_result.dart';

SimulationResult simulateMultiBus(
  SimulationInput input,
) {
  // input
  final params = input.params;
  final arbiter = input.arbiter;
  final N = params.N;
  final M = params.M;
  final Pm = params.Pm;
  final iterations = params.T;
  arbiter.init(params);

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
      if (cpu.blocked) continue;
      if (randomMemoryAccess()) {
        final mem = randomMemory();
        final req = MemoryRequest(t, cpu, mem);
        reqs.add(req);
        cpu.memoryAccesses++;
        cpu.blocked = true;
        continue;
      }
      cpu.pc++;
    }

    // run arbiter
    arbiter(reqs, t);
  }

  return SimulationResult(
    cpus: cpus,
  );
}
