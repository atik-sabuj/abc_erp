import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final Color color;
  final double height;

  const ProgressBar({
    super.key,
    required this.progress,
    this.color = Colors.greenAccent,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: height,
        backgroundColor: Colors.grey.shade800,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}

