import 'package:angry_bird_game/character.dart';
import 'package:angry_bird_game/obstacle.dart';
import 'package:angry_bird_game/slingshot_area.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Character? _character;
  List<Obstacle> _obstacles = [];

  @override
  void initState() {
    super.initState();

    _character = Character(Offset(100, 300), Offset.zero, 40.0);
    _character!.init().then((_) {
      setState(() {});
    });

    _obstacles = [
      Obstacle(Rect.fromLTWH(250, 300, 50, 50)),
      Obstacle(Rect.fromLTWH(350, 300, 50, 50)),
    ];
  }

  void _handleLaunch(Offset launchVector) {
    setState(() {
      final initialVelocity =
          Offset(launchVector.dx * 0.5, launchVector.dy * 0.5);
      if (_character != null) {
        _character!.velocity = initialVelocity;
      }
    });
  }

  void updateGame() {
    if (_character != null) {
      setState(() {
        _character!.update();
        // Check for collisions
        for (var obstacle in _obstacles) {
          if (obstacle.rect.contains(_character!.position)) {
            obstacle.isDestroyed = true;
            // Handle obstacle destruction logic
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    updateGame();

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GamePainter(_character, _obstacles),
              child: SlingshotArea(
                character: _character!,
                onLaunch: _handleLaunch,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                // Action for pause or menu button
              },
              child: Text('Pause'),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Action for restart button
              },
              child: Text('Restart'),
            ),
          ),
        ],
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final Character? character;
  final List<Obstacle> obstacles;

  GamePainter(this.character, this.obstacles);

  @override
  void paint(Canvas canvas, Size size) {
    if (character != null) {
      character!.draw(canvas);
    }

    for (var obstacle in obstacles) {
      obstacle.draw(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
