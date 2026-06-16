import 'package:flutter/material.dart';

const Color _kPrimaryPurple = Color(0xFF6F2BC2);
const Color _kDarkIndigo = Color(0xFF36165E);

class QuizOptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  final bool disabled;

  const QuizOptionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? _kPrimaryPurple.withOpacity(0.12) : Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _kPrimaryPurple.withOpacity(0.12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _kDarkIndigo))),
                const Icon(Icons.chevron_right, color: _kDarkIndigo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
