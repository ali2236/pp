import 'package:pp/model/simulation_arbiter.dart';
import 'package:pp/model/simulation_params.dart';

class SimulationInput {
  final SimulationParams params;
  final SimulationArbiter arbiter;

  SimulationInput(this.params, this.arbiter);
}
