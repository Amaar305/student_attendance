// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class BeeAnimation extends StatefulWidget {
  const BeeAnimation({
    required this.leftOffset,
    required this.duration,
    required this.onEnd,
    super.key,
  });
  final double leftOffset;
  final int duration;
  final VoidCallback onEnd;
  @override
  State<BeeAnimation> createState() => _BeeAnimationState();
}

class _BeeAnimationState extends State<BeeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _position;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );

    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _position = Tween<double>(begin: 0, end: -100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _rotation = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) => widget.onEnd());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          bottom: _position.value,
          left: widget.leftOffset,
          child: Opacity(
            opacity: _opacity.value,
            child: Transform.rotate(
              angle: _rotation.value,
              child: const Text(
                '🐝',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
