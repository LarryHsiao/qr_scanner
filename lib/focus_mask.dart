import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FocusMask extends CustomPainter {
  static const focusImageSizeRate = 0.7;
  final Paint maskPaint = Paint();
  final Rect _detectionArea;

  FocusMask(this._detectionArea) {
    maskPaint.color = const Color.fromARGB(120, 0, 0, 0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTRB(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              _detectionArea,
              const Radius.circular(15),
            ),
          ),
      ),
      maskPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Never repaint.
  }
}
