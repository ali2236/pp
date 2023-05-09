import 'package:flutter/material.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';

class MatrixTable extends StatelessWidget {
  final List<List<num>> items;

  const MatrixTable({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollableTableView(
      columns: [
        const TableViewColumn(label: 'M/B'),
        for (var i = 0; i < items.length; i++) TableViewColumn(label: '$i'),
      ],
      rows: [
        for (var row = 0; row < items.length; row++)
          TableViewRow(
            cells: [
              TableViewCell(
                  child: Text(
                '$row',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
              for (var col = 0; col < items.first.length; col++)
                TableViewCell(child: Text(items[row][col].toStringAsFixed(5))),
            ],
          ),
      ],
    );
  }
}
