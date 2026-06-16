import 'package:flutter/material.dart';

enum BuddyMood { idle, happy }

class AiBuddy extends StatefulWidget {
  final double size;
  final BuddyMood mood;
  const AiBuddy({super.key, this.size = 120, this.mood = BuddyMood.idle});

  @override
  State<AiBuddy> createState() => _AiBuddyState();
}

class _AiBuddyState extends State<AiBuddy> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bob;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _bob = Tween<double>(begin: 0.0, end: 8.0).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);
    _scale = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 0.98, end: 1.02).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 1.02, end: 0.98).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
      ],
    ).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHappy = widget.mood == BuddyMood.happy;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final bobOffset = -_bob.value;
        final scale = isHappy ? 1.08 : _scale.value;
        return Transform.translate(
          offset: Offset(0, bobOffset),
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: isHappy ? const Color(0xFF6F2BC2).withOpacity(0.14) : Colors.pinkAccent.shade100,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12, offset: Offset(0, 6))],
        ),
        child: Center(
          child: Text(isHappy ? '😊' : '🤖', style: const TextStyle(fontSize: 48)),
        ),
      ),
    );
  }
}
