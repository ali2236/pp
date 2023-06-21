import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const TitleCard({
    Key? key,
    required this.title,
    this.subtitle = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.77),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 64),
        child: Center(
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(subtitle),
            ],
          ),
        ),
      ),
    );
  }
}
