import 'package:flutter/material.dart';
import 'package:pp/model/simulation_arbiter.dart';
import 'package:pp/model/simulation_params.dart';
import 'package:pp/widgets/arbiter_simulation_result.dart';
import 'package:pp/widgets/field_num.dart';
import 'package:pp/widgets/title_card.dart';

class SystemSimulator extends StatefulWidget {
  const SystemSimulator({Key? key}) : super(key: key);

  @override
  State<SystemSimulator> createState() => _SystemSimulatorState();
}

class _SystemSimulatorState extends State<SystemSimulator> {
  final params = SimulationParams();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: arbiters.length,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const TitleCard(
                      title: 'شبیه ساز سیستم مولتی باس',
                      subtitle: 'معماری EREW'),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(start: 32),
                    child: Text('ورودی:'),
                  ),
                  inputFields(),
                  Text('$params'),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 24),
                    child: ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        FilledButton(
                          child: const Text('محاسبه'),
                          onPressed: () {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TabBar(tabs: [
                    ...arbiters.keys.map(
                      (n) => Tab(text: n),
                    ),
                  ]),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 1200,
                child: TabBarView(
                  children: arbiters.values
                      .map(
                        (e) => ArbiterSimulationResult(
                          arbiter: e,
                          params: params,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputFields() {
    return GridView.extent(
      maxCrossAxisExtent: 480,
      shrinkWrap: true,
      childAspectRatio: 360 / 50,
      padding: const EdgeInsetsDirectional.only(
        start: 32,
        end: 32,
        top: 16,
        bottom: 8,
      ),
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
        NumberField<int>(
          name: 'Iterations',
          defaultValue: params.T,
          onChange: (v) => params.T = v,
        ),
      ],
    );
  }
}
