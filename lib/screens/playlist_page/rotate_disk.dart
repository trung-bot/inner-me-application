import 'package:flutter/material.dart';

class RotatingDisc extends StatefulWidget {
  final bool isPlaying;
  final double size;

  const RotatingDisc({super.key, required this.isPlaying, this.size = 150});

  @override
  State<RotatingDisc> createState() => _RotatingDiscState();
}

class _RotatingDiscState extends State<RotatingDisc> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // full rotation duration
    )..repeat(); // start rotating
  }

  @override
  void didUpdateWidget(covariant RotatingDisc oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: RotationTransition(
        turns: _controller,
        child: ClipOval(
          child: Image.asset("assets/images/disc.png", fit: BoxFit.cover),
        ),
      ),
    );
  }
}
