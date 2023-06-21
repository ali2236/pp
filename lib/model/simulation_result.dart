import 'dart:math';

import 'package:pp/model/simulation_cpu.dart';

class SimulationResult {
  final List<Cpu> cpus;

  const SimulationResult({required this.cpus});

  double get BWeffective =>
      cpus.map((c) => c.BWeffective).reduce((a, b) => a + b) / cpus.length;

  double get avgWait =>
      cpus.map((c) => c.clksBlocked).reduce((a, b) => a + b) / cpus.length;

  double get variance {
    final aw = avgWait;
    return cpus.map((c) => pow(c.clksBlocked - aw, 2)).reduce((a, b) => a + b) /
        cpus.length;
  }

  double get standardDeviation => sqrt(variance);
}
