import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FocusMask extends CustomPainter {
  static const focusImageSizeRate = 0.7;
  final Paint maskPaint = Paint();

  FocusMask() {
    maskPaint.color = const Color.fromARGB(120, 0, 0, 0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var focusSize = min(size.width, size.height) * focusImageSizeRate;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTRB(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                (size.width / 2) - (focusSize/ 2.0),
                (size.height / 2) - (focusSize / 2.0),
                focusSize,
                focusSize,
              ),
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
