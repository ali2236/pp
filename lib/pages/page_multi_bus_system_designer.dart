import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pp/model/multibus_system.dart';
import 'package:pp/widgets/field_num.dart';
import 'package:pp/widgets/matrix_table.dart';
import 'package:pp/widgets/title_card.dart';

class MultiBusSystemDesigner extends StatefulWidget {
  const MultiBusSystemDesigner({Key? key}) : super(key: key);

  @override
  State<MultiBusSystemDesigner> createState() => _MultiBusSystemDesignerState();
}

class _MultiBusSystemDesignerState extends State<MultiBusSystemDesigner> {
  final designer = MultiBusSystem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: designer,
        builder: (context, _) {
          return ListView(
            children: [
              const TitleCard(title: 'طراح سیستم مولتی باس'),
              const Padding(
                padding: EdgeInsetsDirectional.only(start: 32),
                child: Text('ورودی:'),
              ),
              inputFields(),
              Padding(
                padding:
                    const EdgeInsetsDirectional.only(start: 32, bottom: 16),
                child: Text('N = ${designer.N}'),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.only(start: 32),
                child: Text('جدول دسترسی موثر:'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Card(child: MatrixTable(items: designer.BW)),
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.only(start: 32),
                child: Text('جدول هزینه ها:'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Card(child: MatrixTable(items: designer.cost)),
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.only(start: 32),
                child: Text('بهترین کانفیگ نسبت به هزینه:'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: NumberField<double>(
                  name: 'حداقل دسترسی موثر',
                  defaultValue: designer.BWeffective,
                  onChange: (v) => designer.BWeffective = v,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.only(start: 32, bottom: 16),
                child: Text(
                  'Best Config: (${designer.bestConfig})',
                  textAlign: TextAlign.end,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'ساخته شده توسط علی قنبری',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          );
        },
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
          name: 'Speed Up',
          defaultValue: designer.speedup,
          onChange: (v) => designer.speedup = v,
        ),
        NumberField<double>(
          name: 'درصد سریال',
          defaultValue: designer.fs,
          onChange: (v) => designer.fs = v,
        ),
        NumberField<double>(
          name: 'زمان دسترسی متوسط(Pm)',
          defaultValue: designer.Pm,
          onChange: (v) => designer.Pm = v,
        ),
      ],
    );
  }
}
