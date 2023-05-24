import 'package:pp/model/simulation_cpu.dart';

class SimulationResult {
  final List<Cpu> cpus;

  const SimulationResult({required this.cpus});

  double get BWeffective =>
      cpus.map((c) => c.BWeffective).reduce((a, b) => a + b) / cpus.length;
}
