import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pp/model/simulation_arbiter.dart';
import 'package:pp/model/simulation_params.dart';
import 'package:pp/model/simulation_result.dart';
import 'package:pp/model/system_simulator_simple.dart';
import 'package:pp/widgets/field_num.dart';
import 'package:pp/widgets/title_card.dart';

class SystemSimulator extends StatefulWidget {
  const SystemSimulator({Key? key}) : super(key: key);

  @override
  State<SystemSimulator> createState() => _SystemSimulatorState();
}

class _SystemSimulatorState extends State<SystemSimulator> {
  final params = SimulationParams();
  SimulationResult? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const TitleCard(title: 'شبیه ساز سیستم مولتی باس'),
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 32),
            child: Text('ورودی:'),
          ),
          inputFields(),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 32, vertical: 16),
            child: FilledButton(
              child: const Text('محاسبه'),
              onPressed: () {
                compute<SimulationParams, SimulationResult>(
                        simulateMultiBus, params)
                    .then((r) {
                  setState(() {
                    result = r;
                  });
                });
              },
            ),
          ),
          if (result != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 32, top: 16, bottom: 16),
              child: Text('Avg BWeffective: ${result?.BWeffective}'),
            ),
          const Padding(
            padding: EdgeInsetsDirectional.only(start: 32),
            child: Text('جدول دسترسی موثر:'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Card(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('CPU ID')),
                    DataColumn(label: Text('blocked%')),
                    DataColumn(label: Text('BW effective')),
                  ],
                  rows: result != null
                      ? [
                          for (var cpu in result!.cpus)
                            DataRow(cells: [
                              DataCell(Text('cpu_${cpu.id}')),
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
        ],
      ),
    );
  }

  Widget inputFields() {
    return GridView.extent(
      maxCrossAxisExtent: 720,
      shrinkWrap: true,
      childAspectRatio: 360 / 50,
      padding: const EdgeInsets.all(32),
      crossAxisSpacing: 8,
      mainAxisSpacing: 16,
      children: [
        NumberField<int>(
          name: 'N',
          defaultValue: params.N,
          onChange: (v) => params.N = v,
        ),
        NumberField<int>(
          name: 'M',
          defaultValue: params.M,
          onChange: (v) => params.M = v,
        ),
        NumberField<int>(
          name: 'B',
          defaultValue: params.B,
          onChange: (v) => params.B = v,
        ),
        NumberField<double>(
          name: 'احتمال دسترسی(Pm)',
          defaultValue: params.Pm,
          onChange: (v) => params.Pm = v,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'الگوریتم آربیتر',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            DropdownMenu(
              initialSelection: params.arbiter,
              dropdownMenuEntries: arbiters.entries.map((e) {
                return DropdownMenuEntry(
                  value: e.value,
                  label: e.key,
                );
              }).toList(),
              onSelected: (arbiter) {
                if (arbiter != null) {
                  params.arbiter = arbiter;
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
