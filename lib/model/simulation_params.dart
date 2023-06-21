

class SimulationParams {
  int N, M, B, T;
  double Pm;

  SimulationParams({
    this.N = 10,
    this.M = 10,
    this.B = 10,
    this.T = 1000,
    this.Pm = 0.05,
  });

  @override
  String toString() {
    return 'N=$N, M=$M, B=$B, Pm=$Pm, Iterations=$T';
  }

}
