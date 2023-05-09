import 'dart:math';

import 'package:flutter/material.dart';

class MultiBusSystem with ChangeNotifier {
  MultiBusSystem() {
    _update();
  }

  /// Input Data

  static const _max = 50;

  var _speedup = 40;
  var _fs = 0.01;
  var _Pm = 4 / 100;
  var _BWeffective = 92 / 100;

  int get speedup => _speedup;

  set speedup(int value) {
    _speedup = value;
    _update();
  }

  double get fs => _fs;

  double get fp => 1 - fs;

  set fs(double value) {
    _fs = value;
    _update();
  }

  double get Pm => _Pm;

  set Pm(double value) {
    _Pm = value;
    _update();
  }

  double get BWeffective => _BWeffective;

  set BWeffective(double value) {
    _BWeffective = value;
    _update();
  }

  /// Calculated Data

  int _N = 0;
  List<List<num>> _BW = [[]];
  List<List<num>> _cost = [[]];
  String _bestConf = '';

  int get N => _N;

  List<List<num>> get BW => _BW;

  List<List<num>> get cost => _cost;

  String get bestConfig => _bestConf;

  /// Functions

  int _getNumberOfProcessors(int speedup, double fs) {
    final N = ((speedup * fp) / (1 - (speedup * fs))).round();
    return N;
  }

  List<List<num>> _multiBusSolve(int n, int speedup, double fs, double Pm) {
    final bw = List.generate(_max, (i) => List<num>.generate(_max, (j) => 0.0));
    for (var B = 1; B < _max; B++) {
      for (var M = 1; M < _max; M++) {
        if (B >= M) {
          final t1 = pow(1 - (Pm / M), N);
          final it1 = (1 - t1);
          bw[B][M] = M * it1;
        }
      }
    }
    return bw;
  }

  List<List<num>> _calculateCost(int n) {
    const mem_cost = 1;
    const switch_cost = mem_cost / 5;
    final costs =
        List.generate(_max, (i) => List<num>.generate(_max, (j) => double.infinity));
    for (var b = 1; b < _max; b++) {
      for (var m = 1; m < _max; m++) {
        costs[b][m] =
            (b * n * switch_cost) + (b * m * switch_cost) + (m * mem_cost);
      }
    }
    return costs;
  }

  String _bestConfig(List<List<num>> bw, List<List<num>> cost, double bwe) {
    int selectedB = 0;
    int selectedM = 0;
    var selectedBW = bw[selectedB][selectedM];
    var selectedCost = cost[selectedB][selectedM];
    for (var b = 1; b < _max; b++) {
      for (var m = 1; m < _max; m++) {
        if(bw[b][m] >= bwe){
          final newBw = bw[b][m];
          final newCost = cost[b][m];
          if(newCost < selectedCost){
            selectedB = b;
            selectedM = m;
            selectedBW = newBw;
            selectedCost = newCost;
          }
        }
      }
    }
    return 'B = $selectedB, M = $selectedM';
  }

  /// state

  void _update() {
    _N = _getNumberOfProcessors(speedup, fs);
    _BW = _multiBusSolve(N, speedup, fs, Pm);
    _cost = _calculateCost(N);
    _bestConf = _bestConfig(BW, cost, BWeffective);
    notifyListeners();
  }
}
