import 'package:pp/model/simulation_arbiter.dart';

class SimulationParams {
  int N, M, B;
  double Pm;
  SimulationArbiter arbiter;

  SimulationParams({
    this.N = 10,
    this.M = 10,
    this.B = 10,
    this.Pm = 0.05,
    this.arbiter = const FCFSArbiter(),
  });
}
