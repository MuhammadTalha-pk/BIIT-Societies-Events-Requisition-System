import 'package:flutter/material.dart';

class CustomToggle extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  const CustomToggle({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF00D09E),
        ),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
