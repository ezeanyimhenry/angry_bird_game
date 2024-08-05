import 'package:flutter/material.dart';

class Obstacle {
  Rect rect;
  bool isDestroyed = false;

  Obstacle(this.rect);

  void draw(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, paint);
  }
}
