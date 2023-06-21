import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pp/model/simulation_arbiter.dart';
import 'package:pp/model/simulation_input.dart';
import 'package:pp/model/simulation_params.dart';
import 'package:pp/model/simulation_result.dart';
import 'package:pp/model/system_simulator_simple.dart';

class ArbiterSimulationResult extends StatefulWidget {
  final SimulationArbiter arbiter;
  final SimulationParams params;

  const ArbiterSimulationResult({
    Key? key,
    required this.arbiter,
    required this.params,
  }) : super(key: key);

  @override
  State<ArbiterSimulationResult> createState() =>
      _ArbiterSimulationResultState();
}

class _ArbiterSimulationResultState extends State<ArbiterSimulationResult> {
  SimulationResult? result;

  @override
  void initState() {
    super.initState();
    if (result == null) {
      _calculate();
    }
  }

  @override
  void didUpdateWidget(covariant ArbiterSimulationResult oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculate();
  }

  void _calculate() {
    if (mounted) {
      setState(() {
        result = null;
      });
    }
    final params = widget.params;
    final arbiter = widget.arbiter;
    compute(simulateMultiBus, SimulationInput(params, arbiter)).then((r) {
      if (mounted) {
        setState(() {
          result = r;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(height: 64),
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('در حال محاسبه...'),
        ],
      );
    }
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DataTable(
            rows: [
              DataRow(
                cells: [
                  const DataCell(
                    Text(
                      'Average BW effective',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataCell(Text('${result?.BWeffective}')),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Text(
                    'Average Wait',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text('${result?.avgWait}')),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Text(
                    'Variance',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text('${result?.variance}')),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Text(
                    'Standard Deviation',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  DataCell(Text('${result?.standardDeviation}')),
                ],
              ),
            ],
            columns: const [
              DataColumn(
                  label: Text(
                'معیار',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                'مقدار',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.only(start: 32),
          child: Text('جدول دسترسی موثر:'),
        ),
        SizedBox(
          height: 610,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Card(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('CPU ID')),
                    DataColumn(label: Text('Wait')),
                    DataColumn(label: Text('blocked%')),
                    DataColumn(label: Text('BW effective')),
                  ],
                  rows: result != null
                      ? [
                          for (var cpu in result!.cpus)
                            DataRow(cells: [
                              DataCell(Text('${cpu.id}')),
                              DataCell(Text('${cpu.clksBlocked}')),
                              DataCell(Text(
                                  '${(cpu.percentBlocked * 100).toStringAsFixed(1)}%')),
                              DataCell(
                                  Text(cpu.BWeffective.toStringAsFixed(8))),
                            ])
                        ]
                      : [],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
