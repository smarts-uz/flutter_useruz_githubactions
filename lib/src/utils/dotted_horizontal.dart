import 'package:flutter/material.dart';

class DottedHorizontalLine extends CustomPainter {
  Paint? _paint;
  final Color color;
  final double width;

  DottedHorizontalLine( {
    required this.color,
    required this.width,
  }) {
    _paint = Paint();
    _paint!.color = color;
    _paint!.strokeWidth = 2;
    _paint!.strokeCap = StrokeCap.square;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (double i = 0; i < width; i = i + 4) {
      canvas.drawLine(Offset(i, 0.0), Offset(i + 0.5, 0.0), _paint!);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
