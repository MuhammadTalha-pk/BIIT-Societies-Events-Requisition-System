import 'package:flutter/material.dart';

class CustomTextField4form extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int? maxLines;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon; // Keep it nullable

  const CustomTextField4form({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color textFieldBackgroundColor = Color(0xFFF0FAF6);
    final Color primaryColor = const Color(0xFF00D09E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: maxLines != null && maxLines! > 1 ? maxLines : null,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          expands: false,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: textFieldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            // Adjust contentPadding based on whether there's a suffixIcon
            contentPadding: suffixIcon != null
                ? const EdgeInsets.fromLTRB(
                    16,
                    16,
                    12,
                    16,
                  ) // Less padding on right for suffixIcon
                : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            suffixIcon: suffixIcon,
            hintMaxLines: 1, // Crucial for hint text overflow
          ),
        ),
      ],
    );
  }
}
