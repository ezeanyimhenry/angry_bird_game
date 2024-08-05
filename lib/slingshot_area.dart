// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:angry_bird_game/character.dart';

class SlingshotArea extends StatefulWidget {
  final Character character;
  final Function(Offset) onLaunch;
  const SlingshotArea({
    Key? key,
    required this.character,
    required this.onLaunch,
  }) : super(key: key);

  @override
  _SlingshotAreaState createState() => _SlingshotAreaState();
}

class _SlingshotAreaState extends State<SlingshotArea> {
  Offset _startPosition = Offset.zero;
  Offset _currentPosition = Offset.zero;
  bool _dragging = false;
  bool _gameStarted = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _startPosition = details.localPosition;
          _currentPosition = details.localPosition;
          _dragging = true;
          _gameStarted = true;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _currentPosition = details.localPosition;
        });
      },
      onPanEnd: (details) {
        setState(() {
          _dragging = false;
          final launchVector = _currentPosition - _startPosition;
          widget.onLaunch(launchVector);
        });
      },
      child: Container(
        width: double.infinity,
        height: 100,
        color:
            _gameStarted ? Colors.transparent : Colors.black.withOpacity(0.6),
        child: CustomPaint(
          painter:
              SlingshotPainter(_startPosition, _currentPosition, _dragging),
          child: Center(
            child: Text(
              _gameStarted ? '' : 'Drag to Launch',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class SlingshotPainter extends CustomPainter {
  final Offset startPosition;
  final Offset currentPosition;
  final bool dragging;

  SlingshotPainter(this.startPosition, this.currentPosition, this.dragging);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw slingshot base
    canvas.drawLine(
      Offset(size.width / 2 - 50, size.height),
      Offset(size.width / 2 + 50, size.height),
      paint,
    );

    if (dragging) {
      // Draw drag line
      canvas.drawLine(startPosition, currentPosition, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
