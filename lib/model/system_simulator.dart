/*
import 'dart:typed_data';

abstract class BusArbiter {
  final Bus bus;

  BusArbiter(this.bus);

  Memory getMemory(CPU cpu);
}

class FCFSArbiter extends BusArbiter {



  @override
  Memory getMemory(CPU cpu) {
    // TODO: implement getMemory
    throw UnimplementedError();
  }
}

class Bus {
  final List<CPU> cpus;
  final List<Memory> memories;
  final BusArbiter arbiter;

  Bus(this.cpus, this.memories, this.arbiter);

  Memory getMemory(){

  }
}

class Memory {
  final int id;
  final ByteData _mem;

  Memory(this.id, int length) : _mem = ByteData(length);

  void write(int address, int data){
    if(address < 0 || address > _mem.lengthInBytes){
      throw 'invalid address in memory $id';
    } else {
      _mem.setInt8(address, data);
    }
  }

  int read(int address){
    if(address < 0 || address > _mem.lengthInBytes){
      throw 'invalid address in memory $id';
    } else {
      return _mem.getInt8(address);
    }
  }
}

class CPU {

  final double Pm;
  final Bus bus;
  SimulatedCPU(this.Pm, this.bus);

  static final random = Random();
  var programCounter = 0;
  var memoryAccesses = 0;

  void clk(){

  }

  void program(){
    if(random.nextDouble() <= Pm){
      // do memory access
      bus.getMemory();
      programCounter++;
    } else {
      // cpu operation
      programCounter++;
    }
  }

  void write(int address, int data){

  }

  int read(int address){
    bus.
  }

}*/
