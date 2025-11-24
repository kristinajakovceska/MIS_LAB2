import 'package:flutter/material.dart';

class IngredientChip extends StatelessWidget {
  final String text;
  const IngredientChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      visualDensity: VisualDensity.comfortable,
    );
  }
}
