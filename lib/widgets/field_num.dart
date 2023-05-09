import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberField<T extends num> extends StatelessWidget {
  final String name;
  final T defaultValue;
  final ValueChanged<T> onChange;

  const NumberField({
    Key? key,
    required this.name,
    required this.defaultValue,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: defaultValue.toString());
    return TextField(
      controller: controller,
      inputFormatters: [
        if (T is int) FilteringTextInputFormatter.digitsOnly,
        if (T is double)
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]+.[0-9]+'))
      ],
      onChanged: (v) {
        final parser = T is int ? int.parse : double.parse;
        final val = parser(v);
        onChange(val as T);
      },
      decoration: InputDecoration(
        label: Text(name),
      ),
    );
  }
}
