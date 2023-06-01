import 'package:pp/model/simulation_cpu.dart';

class MemoryRequest {
  final int time;
  final Cpu cpu;
  final int memory;

  const MemoryRequest(this.time, this.cpu, this.memory);

  int get cpuMemoryRequests => cpu.memoryAccesses;

  void fulfill(int t) {
    if (time == t) {
      cpu.effectiveAccesses++;
    }
    cpu.blocked = false;
    cpu.pc++;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryRequest &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          cpu.id == other.cpu.id &&
          memory == other.memory;

  @override
  int get hashCode => time.hashCode ^ cpu.id.hashCode ^ memory.hashCode;
}
