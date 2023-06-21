import 'package:pp/model/simulation_params.dart';
import 'package:pp/model/simulation_request.dart';

Map<String, SimulationArbiter> get arbiters => {
      'Daisy Chain': DaisyChainArbiter(),
      'Rotating Daisy Chain': RotatingDaisyChainArbiter(),
      'Round Robin': RoundRobinArbiter(),
      'Least Used': LUArbiter(),
      'First Come First Served': FCFSArbiter(),
    };

abstract class SimulationArbiter {
  late int N;
  late int B;
  late int M;

  void init(SimulationParams params) {
    N = params.N;
    B = params.B;
    M = params.M;
  }

  void call(List<MemoryRequest> reqs, int t) {
    if (reqs.isNotEmpty) {
      _run(reqs, t);
    }
  }

  /*private*/
  void _run(List<MemoryRequest> reqs, int t);
}

class DaisyChainArbiter extends SimulationArbiter {
  @override
  void _run(List<MemoryRequest> reqs, int t) {
    final accessed = List.filled(M + 1, false);
    for (var b = 0, priority = 0; b < B && priority < N;) {
      final reqIndex = reqs.indexWhere((r) => r.cpu.id == priority);
      if (reqIndex != -1 && !accessed[reqs[reqIndex].memory]) {
        final req = reqs.removeAt(reqIndex);
        req.fulfill(t);
        accessed[req.memory] = true;
        b++;
      }
      priority++;
    }
  }
}

class RotatingDaisyChainArbiter extends SimulationArbiter {
  final priorityCpu = <int, int>{};
  late int maxPriority;

  @override
  void init(SimulationParams params) {
    super.init(params);
    priorityCpu.clear();
    maxPriority = params.N;
  }

  @override
  void _run(List<MemoryRequest> reqs, int t) {
    final accessed = List.filled(M + 1, false);
    final reqCopy = List.of(reqs)..sort(byCpuPriority);
    for (var b = 0, c = 0; b < B && reqs.isNotEmpty && c < reqCopy.length;c++) {
      final req = reqCopy[c];
      if(accessed[req.memory]){
        continue;
      }
      reqs.remove(req);
      req.fulfill(t);
      accessed[req.memory] = true;
      b++;
      priorityCpu[req.cpu.id] = maxPriority++;
    }
  }

  int byCpuPriority(MemoryRequest r1, MemoryRequest r2){
    final r1p = priorityCpu[r1.cpu.id] ?? r1.cpu.id;
    final r2p = priorityCpu[r2.cpu.id] ?? r2.cpu.id;
    return r1p.compareTo(r2p);
  }
}

class RoundRobinArbiter extends SimulationArbiter {
  @override
  void _run(List<MemoryRequest> reqs, int t) {
    final slices = N;
    final sliceGroup = B > slices ? slices : B;
    final accessed = List.filled(M + 1, false);
    for (var b = 0; b < sliceGroup && reqs.isNotEmpty; b++) {
      final allowedCpu = (((t % slices) * sliceGroup) + b) % N;
      final reqIndex = reqs.indexWhere((req) => req.cpu.id == allowedCpu);
      if (reqIndex == -1) continue;
      final req = reqs[reqIndex];
      if (accessed[req.memory]) continue;
      accessed[req.memory] = true;
      reqs.remove(req);
      req.fulfill(t);
    }
  }
}

class FCFSArbiter extends SimulationArbiter {
  @override
  void _run(List<MemoryRequest> reqs, int t) {
    for (var m = 0, b = 0; m < M && b < B; m++) {
      final i = reqs.indexWhere((req) => req.memory == m);
      if (i == -1) continue;
      final req = reqs.removeAt(i);
      req.fulfill(t);
      b++;
    }
  }
}

class LUArbiter extends SimulationArbiter {
  @override
  void _run(List<MemoryRequest> reqs, int t) {
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

  int leastUsedSorter(MemoryRequest m1, MemoryRequest m2) {
    return m2.cpuMemoryRequests.compareTo(m1.cpuMemoryRequests);
  }
}
