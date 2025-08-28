import 'package:flutter/material.dart';

class KnobButton extends StatelessWidget {
  final VoidCallback onPressed;

  const KnobButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.brown.shade800, Colors.brown.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(-2, -2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
