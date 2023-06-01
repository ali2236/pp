import 'package:flutter/material.dart';
import 'package:pp/pages/page_multi_bus_system_designer.dart';
import 'package:pp/pages/page_system_simulator.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _index = 0;

  Widget pageBuilder(int index, BuildContext context) {
    return [
      (context) => const MultiBusSystemDesigner(),
      (context) => const SystemSimulator(),
    ][index](context);
  }

  void _onDestinationSelected(int i) {
    setState(() {
      _index = i;
    });
  }

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.design_services_rounded),
      label: 'MultiBus',
    ),
    NavigationDestination(
      icon: Icon(Icons.design_services_rounded),
      label: 'Simulator',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width <= 800) {
      return Scaffold(
        body: pageBuilder(_index, context),
        bottomNavigationBar: NavigationBar(
          destinations: _destinations,
          onDestinationSelected: _onDestinationSelected,
        ),
      );
    }
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            destinations: _destinations
                .map(
                  (e) => NavigationRailDestination(
                    icon: e.icon,
                    label: Text(e.label),
                  ),
                )
                .toList(),
            onDestinationSelected: _onDestinationSelected,
          ),
          const VerticalDivider(),
          Expanded(child: pageBuilder(_index, context)),
        ],
      ),
    );
  }
}
