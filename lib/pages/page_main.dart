import 'package:flutter/material.dart';
import 'package:pp/pages/page_multi_bus_system_designer.dart';

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
      (context) => const MultiBusSystemDesigner(),
    ][index](context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.design_services_rounded),
                label: Text('MultiBus Designer'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.design_services_rounded),
                label: Text('MultiBus Designer'),
              ),
            ],
            onDestinationSelected: (i){
              setState(() {
                _index = i;
              });
            },
          ),
          const VerticalDivider(),
          Expanded(child: pageBuilder(_index, context)),
        ],
      ),
    );
  }
}
