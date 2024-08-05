import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'dart:ui' as ui;

class Character {
  Offset position;
  Offset velocity;
  final double radius;
  ui.Image? _image;

  Character(this.position, this.velocity, this.radius);

  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load('assets/images/angry-bird.png');
    final List<int> bytes = data.buffer.asUint8List();
    _image = await decodeImageFromList(Uint8List.fromList(bytes));
  }

  void update() {
    // Update position based on velocity
    position = Offset(position.dx + velocity.dx, position.dy + velocity.dy);
  }

  void draw(Canvas canvas) {
    if (_image == null) {
      return;
    }

    final paint = Paint();
    final Rect destRect = Rect.fromCenter(
      center: position,
      width: radius * 2,
      height: radius * 2,
    );

    canvas.drawImageRect(
      _image!,
      Rect.fromLTWH(0, 0, _image!.width.toDouble(), _image!.height.toDouble()),
      destRect,
      paint,
    );
  }

  Future<void> init() async {
    await _loadImage();
  }
}
