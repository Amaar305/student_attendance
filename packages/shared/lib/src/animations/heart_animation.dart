// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class HeartAnimation extends StatefulWidget {
  const HeartAnimation({
    required this.leftOffset,
    required this.duration,
    required this.onEnd,
    super.key,
  });

  final double leftOffset;
  final int duration;
  final VoidCallback onEnd;

  @override
  State<HeartAnimation> createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _position;

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

    _position = Tween<double>(begin: 0, end: -80).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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
            child: const Icon(Icons.favorite, color: Colors.red, size: 24),
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
