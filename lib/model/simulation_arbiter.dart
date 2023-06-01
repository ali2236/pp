import 'package:pp/model/simulation_params.dart';
import 'package:pp/model/simulation_request.dart';

Map<String, SimulationArbiter> get arbiters => {
      'First Come First Served': const FCFSArbiter(),
      'Least Used': const LUArbiter(),
      'Slice': const SliceArbiter(),
    };

abstract class SimulationArbiter {
  const SimulationArbiter();

  void call(SimulationParams params, List<MemoryRequest> reqs, int t);
}

class FCFSArbiter implements SimulationArbiter {
  const FCFSArbiter();

  @override
  void call(SimulationParams params, List<MemoryRequest> reqs, int t) {
    final M = params.M;
    final B = params.B;
    if (reqs.isNotEmpty) {
      for (var m = 0, b = 0; m < M && b < B; m++) {
        final i = reqs.indexWhere((req) => req.memory == m);
        if (i == -1) continue;
        final req = reqs.removeAt(i);
        req.fulfill(t);
        b++;
      }
    }
  }
}

class LUArbiter implements SimulationArbiter {
  const LUArbiter();

  @override
  void call(SimulationParams params, List<MemoryRequest> reqs, int t) {
    final M = params.M;
    final B = params.B;
    if (reqs.isNotEmpty) {
      final leastUsedSortedRequests = List.of(reqs)..sort(leastUsedSorter);

      final accessed = List.filled(M + 1, false);
      for (var i = 0, b = 0; i < leastUsedSortedRequests.length && b < B; i++) {
        final req = leastUsedSortedRequests[i];
        if (accessed[req.memory]) continue;
        accessed[req.memory] = true;
        reqs.remove(req);
        req.fulfill(t);
        b++;
      }
    }
  }

  int leastUsedSorter(MemoryRequest m1, MemoryRequest m2) {
    return m2.cpuMemoryRequests.compareTo(m1.cpuMemoryRequests);
  }
}

class SliceArbiter implements SimulationArbiter {
  const SliceArbiter();

  @override
  void call(SimulationParams params, List<MemoryRequest> reqs, int t) {
    final M = params.M;
    final N = params.N;
    final slices = params.N;
    final sliceGroup = params.B > slices ? slices : params.B;
    final accessed = List.filled(M + 1, false);
    for (var b = 0; b < sliceGroup && reqs.isNotEmpty; b++) {
      final allowedCpu = (((t % slices) * sliceGroup) + b) % N;
      final reqIndex = reqs.indexWhere((req) => req.cpu.id == allowedCpu);
      if(reqIndex == -1) continue;
      final req = reqs[reqIndex];
      if (accessed[req.memory]) continue;
      accessed[req.memory] = true;
      reqs.remove(req);
      req.fulfill(t);
    }
  }
}
